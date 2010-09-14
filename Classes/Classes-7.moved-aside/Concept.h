//
//  Concept.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Document;

@interface Concept :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * originY;
@property (nonatomic, retain) NSNumber * originX;
@property (nonatomic, retain) Concept * parentConcept;
@property (nonatomic, retain) Document * document;
@property (nonatomic, retain) NSSet* concepts;

@end


@interface Concept (CoreDataGeneratedAccessors)
- (void)addConceptsObject:(Concept *)value;
- (void)removeConceptsObject:(Concept *)value;
- (void)addConcepts:(NSSet *)value;
- (void)removeConcepts:(NSSet *)value;

@end

