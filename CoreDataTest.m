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
	
    model = [DATABASE.managedObjectModel retain];
    context = [DATABASE.managedObjectContext retain];
    store = [DATABASE.persistentStore retain];

	theApplication = [DATABASE application];
	
    STAssertNotNil(context, @"Couldn't create new Settings object");
	STAssertNotNil(store, @"no persistent store");
	STAssertNotNil(context, @"no managed object context");
	STAssertNotNil(theApplication, @"no application object");
}

- (void)tearDown {
    [context release];
    store = nil;
    [model release];
    model = nil;
}

- (void)testThatEnvironmentWorks {
    //STAssertNotNil(store, @"no persistent store");

	NSString *name = @"Sam";
    STAssertNotNil(store, @"no persistent store");

    Document *newDocument = [NSEntityDescription insertNewObjectForEntityForName:@"Document" inManagedObjectContext:context];
	newDocument.title = name;
	
	[theApplication addDocumentsObject:newDocument];
    [DATABASE saveManagedObjectContext];

	STAssertTrue([theApplication.documents count] == 1, @"Should be 1 document, but found %i", [theApplication.documents count]);
	
	newDocument = (Document *)[[DATABASE documents] objectAtIndex:0];
	STAssertEqualStrings(newDocument.title, name, @"Titles don't match.  Expected %@, but got %@", name, [(Document *)[[DATABASE documents] objectAtIndex:0] title]);
	
}	

- (void)testCurrentDocumentIsLastDocumentCreated {
	Document *doc;
	NSString *currentDocumentTitle = @"doc 2";
	
    doc = [DATABASE newDocumentTitled:@"doc 1"];
    [DATABASE saveManagedObjectContext];
	
    doc = [DATABASE newDocumentTitled:currentDocumentTitle];
	doc.updated = [doc.updated addTimeInterval:20];
    [DATABASE saveManagedObjectContext];
	
	NSArray *documents = [DATABASE documents];
	doc = (Document *)[documents objectAtIndex:0];
	STAssertTrue([documents count] == 2, @"Should be 2 document, but found %i", [documents count]);
	STAssertEqualStrings(doc.title, currentDocumentTitle, @"Titles don't match.  Expected %@, but got %@", currentDocumentTitle, [(Document *)[[DATABASE documents] objectAtIndex:0] title]);
}

@end