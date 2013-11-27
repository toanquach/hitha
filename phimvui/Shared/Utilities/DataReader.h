//
//  DataReader.h
//  phimvui
//
//  Created by Toan Quach on 11/26/13.
//  Copyright (c) 2013 Toan.Quach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataReader : NSObject

+ (NSArray *)arrReadDataWithKey:(NSString *)keyName;

+ (NSDictionary *)dictReadDataWithKey:(NSString *)keyName;
@end
