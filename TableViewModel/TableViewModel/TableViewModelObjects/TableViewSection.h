//
//  TableViewSection.h
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/19/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TableViewModel;

@interface TableViewSection : NSManagedObject
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSSet *rows;
@property (nonatomic, retain) TableViewModel *table;
@end

@interface TableViewSection (CoreDataGeneratedAccessors)

- (void)addRowsObject:(NSManagedObject *)value;
- (void)removeRowsObject:(NSManagedObject *)value;
- (void)addRows:(NSSet *)values;
- (void)removeRows:(NSSet *)values;

@end
