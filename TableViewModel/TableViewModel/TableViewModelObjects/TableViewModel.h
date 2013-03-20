//
//  TableViewModel.h
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/19/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TableViewModel : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet *sections;
@end

@interface TableViewModel (CoreDataGeneratedAccessors)

- (void)addSectionsObject:(NSManagedObject *)value;
- (void)removeSectionsObject:(NSManagedObject *)value;
- (void)addSections:(NSSet *)values;
- (void)removeSections:(NSSet *)values;

@end
