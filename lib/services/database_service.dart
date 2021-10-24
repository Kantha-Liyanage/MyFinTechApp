import 'dart:async';
import 'package:my_fintech_app/models/account.dart';
import 'package:my_fintech_app/models/budget_category.dart';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseSerivce {
  // make this a singleton class
  DatabaseSerivce._privateConstructor();
  static final DatabaseSerivce instance = DatabaseSerivce._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database = null;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finChat.db');
    return await openDatabase(path, version: 20, onCreate: _onCreate);
  }

  static Future<Database> _getDBConnection() async {
    Database? db = await DatabaseSerivce.instance.database;
    if (db != null) {
      return db;
    }
    throw Exception("Db error");
  }

  Future<FutureOr<void>> _onCreate(Database db, int version) async {
    //Accounts
    await db.execute(
      'CREATE TABLE accounts(id INTEGER PRIMARY KEY, name TEXT UNIQUE, accountType TEXT, currentBalance REAL, offline TEXT)',
    );

    //Categories
    await db.execute(
      'CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT UNIQUE, budgetCategoryType TEXT, budgetAmount REAL, utilizedAmount REAL, offline TEXT)',
    );

    //Offiline Chats
    await db.execute(
      'CREATE TABLE offlinechats(id INTEGER PRIMARY KEY, message TEXT, createdDate TEXT, createdTime TEXT, imagePath TEXT)',
    );

    //Inital values
    Map<String, dynamic> initialAccount = {
      'name': 'Cash',
      'accountType': 'A',
      'currentBalance': 0,
      'offline': 'T'
    };

    Map<String, dynamic> initialCategory = {
      'name': 'Grocery',
      'budgetCategoryType': 'E',
      'budgetAmount': 0,
      'utilizedAmount': 0,
      'offline': 'T'
    };

    await db.insert(
      'accounts',
      initialAccount,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'categories',
      initialCategory,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static createAccount(Account account) async {
    Map<String, dynamic> acc = {
      'name': account.name,
      'accountType': (account.accountType == AccountType.asset ? 'A' : 'L'),
      'currentBalance': 0,
      'offline': account.offline ? 'T' : 'F'
    };

    var db = await _getDBConnection();
    int rowId = await db.insert(
      'accounts',
      acc,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    account.id = rowId;
  }

  static updateAccount(Account account) async {
    Map<String, dynamic> acc = {
      'name': account.name,
      'accountType': (account.accountType == AccountType.asset ? 'A' : 'L'),
      'currentBalance': 0,
      'offline': account.offline ? 'T' : 'F'
    };

    var db = await _getDBConnection();
    await db.update(
      'accounts',
      acc,
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  static createCategory(BudgetCategory category) async {
    Map<String, dynamic> cat = {
      'name': category.name,
      'budgetCategoryType':
          (category.budgetCategoryType == BudgetCategoryType.income
              ? 'I'
              : 'E'),
      'budgetAmount': category.budgetAmount,
      'utilizedAmount': category.utilizedAmount,
      'offline': category.offline ? 'T' : 'F'
    };

    var db = await _getDBConnection();
    int rowId = await db.insert(
      'categories',
      cat,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    category.id = rowId;
  }

  static updateCategory(BudgetCategory category) async {
    Map<String, dynamic> cat = {
      'name': category.name,
      'budgetCategoryType':
          (category.budgetCategoryType == BudgetCategoryType.income
              ? 'I'
              : 'E'),
      'budgetAmount': category.budgetAmount,
      'utilizedAmount': category.utilizedAmount,
      'offline': category.offline ? 'T' : 'F'
    };

    var db = await _getDBConnection();
    await db.update(
      'categories',
      cat,
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  static createOfflineChat(ChatMessage chat) async {
    Map<String, dynamic> acc = {
      'message': chat.message,
      'createdDate': chat.createdDate,
      'createdTime': chat.createdTime,
      'imagePath': chat.imagePath
    };

    var db = await _getDBConnection();
    int rowId = await db.insert(
      'offlinechats',
      acc,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    chat.id = rowId;
  }

  static removeOfflineChat(ChatMessage chat) async {
    var db = await _getDBConnection();
    await db.delete(
      'offlinechats',
      where: 'id = ?',
      whereArgs: [chat.id],
    );
    chat.savedOnline = true;
  }

  static Future<List<Account>> getAccounts() async {
    var db = await _getDBConnection();

    List<Map<String, dynamic>> accountsMap = await db.query('accounts');

    return List.generate(accountsMap.length, (i) {
      return Account(
          accountsMap[i]['id'],
          accountsMap[i]['name'],
          (accountsMap[i]['accountType'] == 'A')
              ? AccountType.asset
              : AccountType.liability,
          accountsMap[i]['currentBalance'],
          (accountsMap[i]['offline'] == 'T' ? true : false));
    });
  }

  static Future<List<BudgetCategory>> getCategories() async {
    var db = await _getDBConnection();

    List<Map<String, dynamic>> categoriesMap = await db.query('categories');

    return List.generate(categoriesMap.length, (i) {
      return BudgetCategory(
        categoriesMap[i]['id'],
        categoriesMap[i]['name'],
        (categoriesMap[i]['budgetCategoryType'] == 'I')
            ? BudgetCategoryType.income
            : BudgetCategoryType.expense,
        categoriesMap[i]['budgetAmount'],
        categoriesMap[i]['utilizedAmount'],
        (categoriesMap[i]['offline'] == 'T' ? true : false),
      );
    });
  }

  static Future<List<ChatMessage>> getOfflineChats() async {
    var db = await _getDBConnection();

    List<Map<String, dynamic>> chatsMap = await db.query('offlinechats');

    return List.generate(chatsMap.length, (i) {
      return ChatMessage(
        chatsMap[i]['id'],
        chatsMap[i]['message'],
        ChatMessageType.userMessage,
        chatsMap[i]['createdDate'],
        chatsMap[i]['createdTime'],
        false,
        false,
        false,
        chatsMap[i]['imagePath'],
      );
    });
  }
}
