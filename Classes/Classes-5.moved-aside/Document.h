//
//  Document.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/12/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Application;
@class Concept;

@interface Document :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * lastSaved;
@property (nonatomic, retain) Application * application;
@property (nonatomic, retain) NSSet* concepts;

@end


@interface Document (CoreDataGeneratedAccessors)
- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)value;
- (void)removeConcepts:(NSSet *)value;

@end

