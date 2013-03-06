//
//  ViewController.m
//  mops
//
//  Created by Alexander Ignatenko on 3/5/13.
//  Copyright (c) 2013 Raizware. All rights reserved.
//

#import "ViewController.h"
#import "ExampleManagedObjectContextPool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ExampleManagedObjectContextPool *pool = [ExampleManagedObjectContextPool sharedPool];
    id blog = [NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:pool.threadContext];
    LogOnError(e, [pool.threadContext save:&e]);

    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        trace(@"bg thread: %@", [NSThread currentThread]);
        NSFetchRequest *r = [[NSFetchRequest alloc] initWithEntityName:@"Blog"];
        id lastBlog;
        for (id blog in [pool.threadContext executeFetchRequest:r error:nil]) {
            trace(@"blog's name is %@", [blog name]);
            lastBlog = blog;
        }
        [lastBlog setName:@"sport"];
        LogOnError(e, [pool.threadContext save:&e]);

        NSManagedObjectContext *tempCtx = pool.newChildContext;
        id aBlog = [tempCtx objectWithID:[lastBlog objectID]];
        [aBlog setName:@"business"];
        LogOnError(e, [tempCtx save:&e]);
    }];

    [blog setName:@"gossips"];
    LogOnError(e, [pool.threadContext save:&e]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
