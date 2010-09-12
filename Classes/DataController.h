//
//  DataController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/9/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Application.h"
#import "Document.h"
#import "Utility.h"

@interface DataController : NSObject <NSFetchedResultsControllerDelegate> {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;		
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSPersistentStore *persistentStore;
	NSFetchedResultsController *fetchedResultsController_;

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSPersistentStore *persistentStore;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

+ (DataController *)sharedDataController;
- (NSString *)applicationDocumentsDirectory;
- (void)saveManagedObjectContext;
- (Application *)application;
- (NSArray *)documents;
- (Document *)currentDocument;
- (Document *)newDocument;
- (Document *)newDocumentTitled:(NSString *)name;

#ifdef AUTOMATED_TESTING
- (void)deletePersistentStore;
#endif

@end
