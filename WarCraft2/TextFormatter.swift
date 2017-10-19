//
//  LineDataSource.swift
//  WarCraft2
//
//  Created by Sam Shahriary on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation

class CTextFormatter {
    
    public static func IntegerToPrettyString(val: Int) -> String {
        
        let SimpleString: String = String(val)
        var ReturnString: String = "" //can't use uninitialzed variables, and can't append to optional
        
        var CharUntilComma: Int = SimpleString.count % 3
        var CharactersLeft = SimpleString.count
        
        
        if 0 == CharUntilComma
        {
            CharUntilComma = 3
        }
        
        for char in SimpleString
        {
            ReturnString += String(char)
            CharUntilComma -= 1
            CharactersLeft -= 1
            if 0 == CharUntilComma
            {
                CharUntilComma = 3
                if(1 <= CharactersLeft)
                {
                    ReturnString += ","
                }
            }
        }
        return ReturnString
    }

}

