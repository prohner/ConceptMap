//
//  Concept.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Document;

@interface Concept :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * bodyString;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * originY;
@property (nonatomic, retain) NSNumber * originX;
@property (nonatomic, retain) Concept * parentConcept;
@property (nonatomic, retain) Document * document;
@property (nonatomic, retain) NSSet* concepts;
@property (nonatomic, retain) NSSet* connectedConcepts;

@end


@interface Concept (CoreDataGeneratedAccessors)
- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)value;
- (void)removeConcepts:(NSSet *)value;

- (void)addConnectedConceptsObject:(Concept *)value;
- (void)removeConnectedConceptsObject:(Concept *)value;
- (void)addConnectedConcepts:(NSSet *)value;
- (void)removeConnectedConcepts:(NSSet *)value;

@end

