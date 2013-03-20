//
//  NSManagedObject+TableViewModel.m
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/20/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import "NSManagedObject+TableViewModel.h"

@implementation NSManagedObject (TableViewModel)

@end

@implementation TableViewModel (TableViewModel)

- (void)eachRow:(void (^)(TableViewRow *row))callback
{
    for (TableViewSection *section in self.sections) {
        for (TableViewRow *row in section.rows) {
            if (callback)
                callback(row);
        }
    }
}

@end