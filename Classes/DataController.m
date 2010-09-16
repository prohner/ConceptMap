//
//  DataController.m
//  ConceptMap
//
//  Created by Preston Rohner on 8/19/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "DataController.h"
#import "SynthesizeSingleton.h"


@implementation DataController

SYNTHESIZE_SINGLETON_FOR_CLASS(DataController);

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize persistentStore;
@synthesize fetchedResultsController=fetchedResultsController_;

#pragma mark -
#pragma mark Core Data stack

//
// managedObjectContext
//
// Accessor. If the context doesn't already exist, it is created and bound to
// the persistent store coordinator for the application
//
// returns the managed object context for the application
//
- (NSManagedObjectContext *)managedObjectContext
{
	if (managedObjectContext != nil)
	{
		return managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil)
	{
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	return managedObjectContext;
}


//
// managedObjectModel
//
// Accessor. If the model doesn't already exist, it is created by merging all of
// the models found in the application bundle.
//
// returns the managed object model for the application.
//
- (NSManagedObjectModel *)managedObjectModel
{
	if (managedObjectModel != nil)
	{
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];	
	return managedObjectModel;
}

//
// persistentStoreCoordinator
//
// Accessor. If the coordinator doesn't already exist, it is created and the
// application's store added to it.
//
// returns the persistent store coordinator for the application.
//
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
	if (persistentStoreCoordinator != nil)
	{
		return persistentStoreCoordinator;
	}
	
	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
#ifdef AUTOMATED_TESTING
	persistentStore = [persistentStoreCoordinator addPersistentStoreWithType: NSInMemoryStoreType 
															   configuration: nil 
																		 URL: nil
																	 options: nil
																	   error: NULL];
#else
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"ConceptMap.sqlite"]];
	
	persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
															   configuration:nil 
																		 URL:storeURL 
																	 options:nil 
																	   error:&error];
#endif
	if (!persistentStore) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}	
	
	return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)saveManagedObjectContext {
	NSError *error = nil;
	
	if (![[self managedObjectContext] save: &error]) {
		NSLog(@"Error while saving\n%@",
			  ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
		exit(1);
	}
	
	//	[managedObjectContext release];
	managedObjectContext = nil;
	
	[NSFetchedResultsController deleteCacheWithName:@"Root"];
	[fetchedResultsController_ release];
	fetchedResultsController_ = nil;
}


#ifdef AUTOMATED_TESTING

- (void)deletePersistentStore {
    NSError *error = nil;
	if (persistentStoreCoordinator && persistentStore) {
		[persistentStoreCoordinator removePersistentStore: persistentStore error: &error];
	}
	
	//	[managedObjectModel release];
	//	if (managedObjectContext) {
	//		[managedObjectContext release];		
	//	}
	//	[persistentStoreCoordinator release];
	//	[persistentStore release];
	
	managedObjectModel = nil;
	managedObjectContext = nil;		
	persistentStoreCoordinator = nil;
	persistentStore = nil;
	
}

#endif

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
	 */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastSaved" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}    


- (Application *)application {
	Application *app;
	NSEntityDescription *settingsEntity = [[[self managedObjectModel] entitiesByName] objectForKey:@"Application"];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:settingsEntity];
	
	NSError *error = nil;
	NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
	
	if (array && [array count] == 1) {
		app = (Application *)[array objectAtIndex:0];
	} else {
		app = (Application *)[NSEntityDescription insertNewObjectForEntityForName:@"Application" inManagedObjectContext:[self managedObjectContext]];
	}
	return app;
}

- (NSArray *)documents {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
	return sectionInfo.objects;
	//	return [[NSArray alloc] init];
}

- (Document *)currentDocument {
	Document *currentDocument = (Document *)[[DATABASE documents] objectAtIndex:0];
	
	return currentDocument;
}

- (Document *)newDocumentTitled:(NSString *)name {
	Document *doc;
    doc = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:[self managedObjectContext]];
	doc.title = name;
	doc.created = [NSDate date];
	doc.lastSaved = [NSDate date];
	[[self application] addDocumentsObject:doc];
	return doc;
}

- (Document *)newDocument {
	return [self newDocumentTitled:@"My New Document"];
}

- (Concept *)newConceptTitled:(NSString *)name toDocument:(Document *)doc {
	Concept *concept;
    concept = [NSEntityDescription insertNewObjectForEntityForName:@"Concept" inManagedObjectContext:[self managedObjectContext]];
	concept.title = name;
	[doc addConceptsObject:concept];
	return concept;
	
}

@end

@implementation Concept(AutoPopulateFields)
- (void)awakeFromInsert {
	[self setValue:[NSDate date] forKey:@"created"];
}
- (void)willSave {
	[self setPrimitiveValue: [NSDate date] forKey: @"lastSaved"];
}
- (void)setRect:(CGRect)r {
	FUNCTION_LOG();
	self.originX = [NSNumber numberWithInt: r.origin.x];
	self.originY = [NSNumber numberWithInt: r.origin.y];
	self.height = [NSNumber numberWithInt: r.size.height];
	self.width = [NSNumber numberWithInt: r.size.width];

//	FUNCTION_LOG(@"%@ %@ (%@, %@) (%@, %@)", self, self.title, self.originX, self.originY, self.width, self.height);
	
}
@end

@implementation Document(AutoPopulateFields)
- (void)awakeFromInsert {
	[self setValue:[NSDate date] forKey:@"created"];
	[self setValue:[NSDate date] forKey:@"lastSaved"];
}

- (void)willSave {
    [self setPrimitiveValue: [NSDate date] forKey: @"lastSaved"];
}

@end