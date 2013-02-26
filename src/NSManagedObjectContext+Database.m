#define Save(ctx) NSError *e; if (![ctx save:&e]) log_error(e);
#define ChainSave(ctx) NSError *e; if (![ctx chainSave:&e]) log_error(e);
@interface NSManagedObjectContext (Database)
- (id)objectThroughContext:(NSManagedObject *)object;
+ (NSManagedObjectContext *)threadContext;
- (NSManagedObjectContext *)newChildContext;
- (BOOL)chainSave:(NSError **)error;
@end

// Save(context);
// ChainSave(context);
