//
//  DataReader.m
//  phimvui
//
//  Created by Toan Quach on 11/26/13.
//  Copyright (c) 2013 Toan.Quach. All rights reserved.
//

#import "DataReader.h"

@implementation DataReader

+ (NSArray *)arrReadDataWithKey:(NSString *)keyName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"datafilm" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    for (NSString *key in dict.allKeys)
    {
        if ([key isEqualToString:keyName])
        {
            return [dict objectForKey:keyName];
        }
    }
    
    return nil;
}

+ (NSDictionary *)dictReadDataWithKey:(NSString *)keyName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"datafilm" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    for (NSString *key in dict.allKeys)
    {
        if ([key isEqualToString:keyName])
        {
            return [dict objectForKey:keyName];
        }
    }
    
    return nil;
}
@end
