//
//  NSManagedObject+Update.m
//  mapping
//
//  Created by Alexander Ignatenko on 3/8/13.
//  Copyright (c) 2013 Alexander Ignatenko. All rights reserved.
//

#import "NSManagedObject+Update.h"

@implementation NSManagedObject (Update)

- (void)updateWithValues:(NSDictionary *)values;
{
    NSEntityDescription *entity = self.entity;
    for (NSPropertyDescription *prop in entity.properties) {
        if (prop.isTransient)
            continue;

        if ([prop isKindOfClass:[NSAttributeDescription class]]) {
            NSString *name = prop.name;

            // How to deal with NSTransformableAttributeType ?
        }


        // TODO: relationships
        // TODO: to-many
    }
}

- (NSDictionary *)values
{
    return nil;
}

- (NSArray *)exportKeys
{
    return nil;
}

@end
