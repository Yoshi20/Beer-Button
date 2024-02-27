import { Dexie } from "dexie" // dexie.js (indexedDB wrapper)

class LocalDB {
  constructor(dbName) {
    if (!this.db) {
      this.db = new Dexie(dbName);
      console.log('db:',this.db);//blup
      this.db.version(1).stores({
        forms: "++id", // NOTE: Don’t declare all columns like in SQL. You only declare properties you want to index, that is properties you want to use in a where(…) query.
      });
    }
    this.db.open().then(function (db) {
      console.log("Found database: " + db.name);
      console.log("Database version: " + db.verno);
      db.tables.forEach(function (table) {
        console.log("Found table: " + table.name);
        console.log("Table Schema: " + JSON.stringify(table.schema, null, 4));
      });
    })
    .catch("NoSuchDatabaseError", function (e) {
      // Database with that name did not exist
      console.error("Database not found");
    })
    .catch(function (e) {
      console.error("Oh uh: " + e);
    });
  };

}

export const db = new LocalDB("LocalDatabase").db;

export default {
  db,
};
