//
//  UIDocument+ConvenienceMethods.m
//  snippets-objc
//
//  Created by Alexander Ignatenko on 10/24/12.
//  Copyright (c) 2012 Alexander Ignatenko. All rights reserved.
//

#import "UIDocument+ConvenienceMethods.h"

@implementation UIDocument (ConvenienceMethods)

- (void)saveCreating
{
    [self saveToURL:self.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        if (NO == success)
            log_warning(@"Fail to create document at path %@", self.fileURL.path);
    }];
}

- (void)saveOverwriting
{
    [self saveToURL:self.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
        if (NO == success)
            log_warning(@"Fail to save document at path %@", self.fileURL.path);
    }];
}

- (void)saveCreatingWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
    [self saveToURL:self.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:completionHandler];
}

- (void)saveOverwritingWithCompletionHandler:(void (^)(BOOL success))completionHandler
{
    [self saveToURL:self.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:completionHandler];
}

@end
