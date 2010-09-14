//
//  Concept.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/10/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Document;

@interface Concept :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Document * document;
@property (nonatomic, retain) Concept * parentConcept;
@property (nonatomic, retain) NSSet* concepts;

@end


@interface Concept (CoreDataGeneratedAccessors)
- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)value;
- (void)removeConcepts:(NSSet *)value;

@end

