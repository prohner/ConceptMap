//
//  Document.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Document :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet* concepts;

@end


@interface Document (CoreDataGeneratedAccessors)
- (void)addConceptsObject:(NSManagedObject *)value;
- (void)removeConceptsObject:(NSManagedObject *)value;
- (void)addConcepts:(NSSet *)value;
- (void)removeConcepts:(NSSet *)value;

@end

