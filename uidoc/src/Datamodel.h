//
//  Datamodel.h
//  snippets-objc
//
//  Created by Alexander Ignatenko on 10/31/12.
//  Copyright (c) 2012 Alexander Ignatenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Datamodel : NSObject

+ (Datamodel *)sharedModel;

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
- (NSManagedObjectContext *)newBackgroundManagedObjectContext;

- (void)openWithCompletion:(void (^)(BOOL success, NSError *error))completion;
- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completion;
- (void)closeWithCompletion:(void (^)(BOOL success, NSError *error))completion;

// Both methods invoke |completion| block on the calling queue
- (void)executeFetchRequest:(NSFetchRequest *)request completion:(void (^)(NSArray *objects, NSError *error))completion;
- (void)countForFetchRequest:(NSFetchRequest *)request completion:(void (^)(NSUInteger count, NSError *error))completion;

@end

typedef NS_ENUM(NSInteger, DatamodelErrorCode)
{
    DatamodelErrorCodeFailToOpen = 0,
    DatamodelErrorCodeFailToSave,
    DatamodelErrorCodeFailToClose
};
