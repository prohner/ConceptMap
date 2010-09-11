//
//  CoreDataTest.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/9/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.

#import "GTMSenTestCase.h"
#import <CoreData/CoreData.h>
#import "DataController.h"

@interface CoreDataTest : SenTestCase {
    NSPersistentStoreCoordinator *coord;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
    NSPersistentStore *store;
}

@end
