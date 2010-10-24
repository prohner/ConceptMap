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
#import "Concept.h"
#import "DataController.h"

@class ConceptObject;

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
- (Concept *)newConceptTitled:(NSString *)name toDocument:(Document *)doc;
- (Concept *)newConceptTitled:(NSString *)name toDocument:(Document *)doc withRect:(CGRect)r;

#ifdef AUTOMATED_TESTING
- (void)deletePersistentStore;
#endif

@end

@interface Concept(SettingData)
- (void)addConcept:(Concept *)newConcept;
- (void)setRect:(CGRect)r;
- (void)removeConceptAndConnections:(Concept *)conceptToRemove;
@end

@interface Concept(Geometry) 

- (void)setConceptObject:(ConceptObject *)container;
- (ConceptObject *)conceptObject;
	
- (CGPoint)centerPoint;

@end

