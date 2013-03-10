//
//  NSManagedObject+Update.h
//  mapping
//
//  Created by Alexander Ignatenko on 3/8/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

typedef NS_ENUM(NSInteger, SMPKeysConvertionType)
{
    SMPKeysConvertionTypeCamelCase = 0,    // CamelCase
    SMPKeysConvertionTypeCamelBack,        // camelCase
    SMPKeysConvertionTypeSnakeCase,        // snake_case
    SMPKeysConvertionTypeCustom            // provide your own implementation
};

@protocol SMPKeysConverter <NSObject>

- (NSString *)exportKey:(NSString *)key;

@end

@interface NSManagedObject (Update)
- (void)updateWithValues:(NSDictionary *)values;
- (NSDictionary *)values;
- (NSArray *)exportKeys;
@end
