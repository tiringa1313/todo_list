import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:todo_list_provider/app/core/database/migrations/migration.dart';
import 'package:todo_list_provider/app/core/database/sqlite_migration_factory.dart';

class SqliteConnectionFactory {
  static const _VERSION = 1;
  static const _DATABASE_NAME = 'TODO_LIST_PROVIDER.db';

  Database? _db;
  final _lock = Lock();

  static SqliteConnectionFactory? _instance;

  // Construtor privado
  SqliteConnectionFactory._();

  factory SqliteConnectionFactory() {
    _instance ??= SqliteConnectionFactory._();
    return _instance!;
  }

  // Metodo para abrir a conexao utilizando Lock, para nao abrir mais de uma
  // conexao simultanea prejudicando o DB.
  Future<Database> openConnection() async {
    var databasePath = await getDatabasesPath();
    var dataBasePathFinal = join(databasePath, _DATABASE_NAME);

    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          _db = await openDatabase(
            dataBasePathFinal,
            version: _VERSION,
            onConfigure: _onConfigure,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
            onDowngrade: _onDowngrade,
          );
        }
      });
    }

    return _db!;
  }

  // Metodo para fechar a conexao com o DB

  void closeConnection() {
    _db?.close();
    _db = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  //******************************************************************************* */
  // Função chamada automaticamente quando o banco de dados é criado pela primeira vez

  Future<void> _onCreate(Database db, int version) async {
    // Cria um batch para executar múltiplas operações no banco de forma agrupada
    //batch é um recurso do Sqlite
    final batch = db.batch();

    // Obtém a lista de migrations de criação de tabelas iniciais
    final migrations = SqliteMigrationFactory().getCreateMigration();

    // Para cada migration, executa o método create, adicionando comandos ao batch
    for (var migration in migrations) {
      migration.create(batch);
    }

    // Executa todos os comandos do batch de uma só vez no banco
    await batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int version) async {
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getUpgradeMigration(oldVersion);

    for (var migration in migrations) {
      migration.update(batch);
    }

    batch.commit();
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int version) async {}
}
