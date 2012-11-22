//
//  Datamodel.m
//  snippets-objc
//
//  Created by Alexander Ignatenko on 10/31/12.
//  Copyright (c) 2012 Alexander Ignatenko. All rights reserved.
//

#import "Datamodel.h"
#import "UIDocument+ConvenienceMethods.h"

static NSString *const DatamodelErrorDomain = @"DatamodelErrorDomain";

@interface Datamodel ()

@end

@implementation Datamodel
{
@private
    UIManagedDocument *_document;
}

+ (Datamodel *)sharedModel
{
    static Datamodel *SharedDatamodel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedDatamodel = [[Datamodel alloc] init];
    });
    return SharedDatamodel;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _document.managedObjectContext;
}

- (void)openWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *docURL = [fm URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask].lastObject;
    docURL = [docURL URLByAppendingPathComponent:@"database"];
    if (nil == _document) {
        _document = [[UIManagedDocument alloc] initWithFileURL:docURL];
        // Specify model name if you have more than one xcdatamodel included to the project
//        _document.modelConfiguration = [[NSBundle mainBundle] pathForResource:@"CustomModelName" ofType:@"mom"];
    }
    if (![fm fileExistsAtPath:docURL.path])
        [_document saveCreatingWithCompletionHandler:^(BOOL success) {
            NSError *e;
            if (NO == success) {
                    e = [self errorWithCode:DatamodelErrorCodeFailToOpen
                 localizedDescriptionFormat:@"Fail to create document at path %@", docURL.path];
            }
            if (completion)
                completion(success, e);
        }];
    else
        [_document openWithCompletionHandler:^(BOOL success) {
            NSError *e;
            if (NO == success) {
                e = [self errorWithCode:DatamodelErrorCodeFailToOpen
             localizedDescriptionFormat:@"Fail to open document at path %@", docURL.path];
            }
            if (completion)
                completion(success, e);
        }];
}

- (void)saveWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    if (nil == _document) {
        NSError *e = [self errorWithCode:DatamodelErrorCodeFailToSave
              localizedDescriptionFormat:@"Fail to save datamodel. Datamodel is not opened"];
        if (completion)
            completion(NO, e);
        return;
    }

    [_document saveOverwritingWithCompletionHandler:^(BOOL success) {
        NSError *e;
        if (NO == success) {
            e = [self errorWithCode:DatamodelErrorCodeFailToSave
                  localizedDescriptionFormat:@"Fail to save datamodel"];
        }
        if (completion)
            completion(success, e);
    }];
}

- (void)closeWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    if (nil == _document) {
        if (completion)
            completion(YES, nil);
        return;
    }

    [_document closeWithCompletionHandler:^(BOOL success) {
        NSError *e;
        if (NO == success) {
            e = [self errorWithCode:DatamodelErrorCodeFailToClose
         localizedDescriptionFormat:@"Fail to close datamodel"];
        }
        if (completion)
            completion(success, e);
    }];
}

- (NSManagedObjectContext *)newBackgroundManagedObjectContext
{
    NSManagedObjectContext *managedObjectContext =
    [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    NSAssert(_document != nil, @"Fail to init managed object context for private queue. Datamodel is not opened");
    managedObjectContext.parentContext = _document.managedObjectContext;
    return managedObjectContext;
}

- (void)executeFetchRequest:(NSFetchRequest *)request completion:(void (^)(NSArray *objects, NSError *error))completion
{
    dispatch_queue_t callingQueue = dispatch_get_current_queue();
    NSManagedObjectContext *ctx = self.newBackgroundManagedObjectContext;
    [ctx performBlock:^{
        NSError *error;
        NSArray *objects = [ctx executeFetchRequest:request error:&error];
        if (completion)
            dispatch_async(callingQueue, ^{
                completion(objects, error);
            });
    }];
}

- (void)countForFetchRequest:(NSFetchRequest *)request completion:(void (^)(NSUInteger count, NSError *error))completion
{
    dispatch_queue_t callingQueue = dispatch_get_current_queue();
    NSManagedObjectContext *ctx = self.newBackgroundManagedObjectContext;
    [ctx performBlock:^{
        NSError *error;
        NSUInteger count = [ctx countForFetchRequest:request error:&error];
        if (completion)
            dispatch_async(callingQueue, ^{
                completion(count, error);
            });
    }];
}

#pragma mark - Utils

- (NSError *)errorWithCode:(NSInteger)code localizedDescriptionFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *description = [NSString stringWithFormat:format, ap];
    va_end(ap);
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : description};
    NSError *error = [NSError errorWithDomain:DatamodelErrorDomain code:code userInfo:userInfo];
    return error;
}

@end
