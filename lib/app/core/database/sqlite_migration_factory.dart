import 'package:todo_list_provider/app/core/database/migrations/migration.dart';
import 'package:todo_list_provider/app/core/database/migrations/migration_v1.dart';
import 'package:todo_list_provider/app/core/database/migrations/migration_v2.dart';

class SqliteMigrationFactory {
  List<Migration> getCreateMigration() => [MigrationV1(), MigrationV2()];

  List<Migration> getUpgradeMigration(int version) {
    final migrations = <Migration>[];
    // se a versao do DB do cel da pessoa for 1, mas nosso app esta na versao 3
    // precisamos atualizar o DB com as versoes posteriores
    if (version == 1) {
      migrations.add(MigrationV2());
      //migrations.add(MigrationV3());
    }

    // Se o app da pessoa esta na versao 2 ja, so atualiza a V3 que seria a ultima
    // versao disponivel para atualizacao
    if (version == 2) {
      //migrations.add(MigrationV3());
    }

    return migrations;
  }
}
