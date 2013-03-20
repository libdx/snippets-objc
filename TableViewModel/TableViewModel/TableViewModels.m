//
//  TableViewModels.m
//  TableViewModel
//
//  Created by Alexander Ignatenko on 3/18/13.
//  Copyright (c) 2013 example. All rights reserved.
//

#import "TableViewModels.h"
#import "TableViewModelObjects.h"

@implementation TableViewModelManager (TableViewModels)

NSString *const DetailedTableViewModelID = @"DetailedTableViewModelID";

- (TableViewModel *)detailedTableViewModel
{
    TableViewModel *model;
    model = [self modelWithID:DetailedTableViewModelID];
    if (model)
        return model;

    model = [self createModelWithID:DetailedTableViewModelID];
    [self newSectionWithModel:model rows:@[
        @{@"cellReuseIdentifier" : @"AuthorCellID"},
        @{@"cellReuseIdentifier" : @"TitleCellID"}
    ]];
    [self newSectionWithModel:model rows:@[
        @{@"cellReuseIdentifier" : @"ItemCellID"},
    ]];
    [self newSectionWithModel:model rows:@[
        @{@"cellReuseIdentifier" : @"AddItemCellID"},
    ]];

    NSError *error;
    if (![self.managedObjectContext save:&error]) NSLog(@"[ERROR] %@", error);

    return model;
}

- (TableViewModel *)modelWithID:(NSString *)ID
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TableViewModel"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", ID];
    NSError *error;
    TableViewModel *model = [self.managedObjectContext executeFetchRequest:request error:&error].lastObject;
    if (error) NSLog(@"[ERROR] %@", error);
    return model;
}

- (TableViewModel *)createModelWithID:(NSString *)ID
{
    TableViewModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"TableViewModel"
                                          inManagedObjectContext:self.managedObjectContext];
    model.identifier = ID;
    return model;

}

- (TableViewSection *)newSectionWithModel:(TableViewModel *)model rows:(NSArray *)rows // array of dicts
{
    TableViewSection *section = [NSEntityDescription insertNewObjectForEntityForName:@"TableViewSection"
                                                              inManagedObjectContext:self.managedObjectContext];

    NSInteger position = 0;
    for (NSDictionary *rowInfo in rows) {
        TableViewRow *row = [NSEntityDescription insertNewObjectForEntityForName:@"TableViewRow"
                                                          inManagedObjectContext:self.managedObjectContext];
        row.position = @(position);
        for (NSString *key in rowInfo) {
            [row setValue:rowInfo[key] forKey:key];
        }
        ++position;
        [section addRowsObject:row];
    }
    [self addSection:section toModel:model];
    return section;
}

- (void)addSection:(TableViewSection *)section toModel:(TableViewModel *)model
{
    section.position = @(model.sections.count);
    [model addSectionsObject:section];
}

@end
