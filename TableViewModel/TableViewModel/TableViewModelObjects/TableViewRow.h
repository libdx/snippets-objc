//
//  TableViewRow.h
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/20/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TableViewSection;

@interface TableViewRow : NSManagedObject

@property (nonatomic, retain) NSString * cellReuseIdentifier;
@property (nonatomic, retain) NSNumber * shouldIndentWhileEditing;
@property (nonatomic, retain) id boundObject;
@property (nonatomic, retain) id didSelectCallback;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) TableViewSection *section;

@end
