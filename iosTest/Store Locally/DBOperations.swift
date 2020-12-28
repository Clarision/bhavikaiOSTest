//
//  DBOperations.swift
//  iosTest
//
//  Created by macmini on 28/12/20.
//

import Foundation
import UIKit
import SQLite3

class DBOperations
{
    let dbPath: String = "UserData.sqlite"
    var userList = [UserListModel]()
    var db: OpaquePointer?
    
    //MARK: CREATE DATABASE
    func openDatabase()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        //var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
        }
        //MARK : CREATE TABLE
        let createTableString = "CREATE TABLE IF NOT EXISTS User (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, userid INTEGER, date TEXT)"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Users table created.")
            }
            else
            {
                print("Users table could not be created.")
            }
        }
        else
        {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
        
    }
     //MARK: INSERT QUERY
    func insert(name:String, id: Int, date: String) -> String?
    {
        var err = ""
        let insertStatementString = "INSERT INTO User (username, userid, date) VALUES (?,?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, Int32(id))
            sqlite3_bind_text(insertStatement, 3, (date as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE
            {
                print("Successfully inserted row.")
                err = ""
            }
            else
            {
                print("Could not insert row.")
                err = "Could not insert row."
            }
        }
        else
        {
            print("INSERT statement could not be prepared.")
            err = "INSERT statement could not be prepared."
        }
        sqlite3_finalize(insertStatement)
        return err
    }
    //MARK: READ FROM DB
    func read()
    {
        let queryStatementString = "SELECT * FROM User;"
        var queryStatement: OpaquePointer? = nil
        userList.removeAll()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK
        {
            while sqlite3_step(queryStatement) == SQLITE_ROW
            {
                let id = sqlite3_column_int(queryStatement, 0)
                print(id)
                let name = String(cString: sqlite3_column_text(queryStatement, 1))
                let uid = sqlite3_column_int(queryStatement, 2)
                let date = String(cString: sqlite3_column_text(queryStatement, 3))
                let dateTimeStamp = date.convertSTringToDate()
                userList.append(UserListModel(userId: Int(uid), userName: name, created_at: dateTimeStamp))
                print("Query Result: \(name)")
            }
        }
        else
        {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
    }
    //MARK: DELETE FROM DB
    func deleteByID()
    {
        let deleteStatementStirng = "DELETE FROM User;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK
        {
//            sqlite3_bind_int(deleteStatement, 0, Int32(Int(id)))
            if sqlite3_step(deleteStatement) == SQLITE_DONE
            {
                print("Successfully deleted row.")
            }
            else
            {
                print("Could not delete row.")
            }
        }
        else
        {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        read()
    }
}
