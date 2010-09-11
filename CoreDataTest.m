//
//  CoreDataTest.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/9/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "CoreDataTest.h"


@implementation CoreDataTest

- (void)setUp {
	[[DataController sharedDataController] deletePersistentStore];
	
    model = [[DataController sharedDataController].managedObjectModel retain];
    store = [[DataController sharedDataController].persistentStore retain];
    context = [[DataController sharedDataController].managedObjectContext retain];

    STAssertNotNil(context, @"Couldn't create new Settings object");
//	STAssertNotNil(store, @"no persistent store");
	STAssertNotNil(context, @"no managed object context");
}

- (void)tearDown {
    [context release];
    store = nil;
    [model release];
    model = nil;
}

- (void)testThatEnvironmentWorks {
	NSString *name = @"Sam";
//    STAssertNotNil(store, @"no persistent store");
	STAssertTrue(1 == 1, @"Testing");
	NSError *error = nil;
}	

@end
