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
	
    doc = [DATABASE newDocumentTitled:currentDocumentTitle];
	doc.lastSaved = [doc.lastSaved addTimeInterval:20];
    [DATABASE saveManagedObjectContext];
	
	doc = theApplication.currentDocument;
	STAssertTrue([theApplication.documents count] == 2, @"Should be 2 document, but found %i", [theApplication.documents count]);
	STAssertEqualStrings(doc.title, currentDocumentTitle, @"Titles don't match.  Expected %@, but got %@", currentDocumentTitle, [(Document *)[[DATABASE documents] objectAtIndex:0] title]);
}

- (void)testDocumentDatesAreMaintained {
	Document *doc;
	
    doc = [DATABASE newDocumentTitled:@"doc 1"];
    [DATABASE saveManagedObjectContext];
		
	NSArray *documents = [DATABASE documents];
	doc = (Document *)[documents objectAtIndex:0];
    STAssertNotNil(doc.created, @"The created date should have been set.");
    STAssertNotNil(doc.lastSaved, @"The updated date should have been set.");
	
}

- (void)testApplicationCurrentDocumentIsMaintained {
	NSString *lastDocTitle = @"doc 2";
	[DATABASE newDocumentTitled:@"doc 1"];
	[DATABASE newDocumentTitled:lastDocTitle];
    [DATABASE saveManagedObjectContext];
	
	Document *doc = theApplication.currentDocument;
    STAssertEqualStrings(doc.title, lastDocTitle, @"", @"");
	
}

- (void)testAddingConcepts {
	Document *doc;
	Concept *concept;
	
    doc = [DATABASE newDocumentTitled:@"doc 1"];
	concept = [DATABASE newConceptTitled:@"concept 1" toDocument:doc];
    STAssertNotNil(concept.created, @"The created date should have been set.");
	
	concept = [DATABASE newConceptTitled:@"concept 2" toDocument:doc];
    [DATABASE saveManagedObjectContext];
}

- (void)testContainingConcepts {
	Document *doc;
	Concept *conceptOuter;
	Concept *conceptInner;
	
    doc = [DATABASE newDocumentTitled:@"doc 1"];
	conceptOuter = [DATABASE newConceptTitled:@"concept outer" toDocument:doc];
	conceptInner = [DATABASE newConceptTitled:@"concept inner" toDocument:doc];
	
	[conceptOuter addConcept:conceptInner];
	STAssertTrue(conceptInner.parentConcept == conceptOuter, @"Contained concept's parent should be set");
	
    [DATABASE saveManagedObjectContext];
}

- (void)testConceptDatesAreMaintained {
	Document *doc;
	Concept *concept;
	ColorSchemeConstant color1 = ColorSchemeConstantBlue;
	ColorSchemeConstant color2 = ColorSchemeConstantPurple;
	

    doc = [DATABASE newDocumentTitled:@"doc 1"];
	concept = [DATABASE newConceptTitled:@"concept 1" toDocument:doc];
	concept.colorSchemeConstant = [NSNumber numberWithInt:color1];

	concept = [DATABASE newConceptTitled:@"concept 2" toDocument:doc];
	concept.colorSchemeConstant = [NSNumber numberWithInt:color2];
    [DATABASE saveManagedObjectContext];
	
	NSArray *documents = [DATABASE documents];
	doc = (Document *)[documents objectAtIndex:0];

	STAssertTrue([[doc concepts] count] == 2, @"Wrong number of concepts");
	for (Concept *concept in [doc concepts]) {
		STAssertNotNil(concept, @"The concept was not found.");
		STAssertNotNil(concept.lastSaved, @"The last saved date should have been set.");
		if ([concept.title isEqualToString:@"concept 1"]) {
			STAssertTrue([concept.colorSchemeConstant intValue] == color1, @"%@ color is %@ and should be %i", concept.title, concept.colorSchemeConstant, color1);
		} else {
			STAssertTrue([concept.colorSchemeConstant intValue] == color2, @"%@ color is %@ and should be %i", concept.title, concept.colorSchemeConstant, color2);
		}

	}	
}

@end
