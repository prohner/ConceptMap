//
//  ConceptMapView.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptMapView.h"


@implementation ConceptMapView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		ConceptObject *co1 = [[ConceptObject alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
		co1.backgroundColor = [UIColor purpleColor];
		[self addSubview:co1];

		ConceptObject *co2 = [[ConceptObject alloc] initWithFrame:CGRectMake(700, 700, 200, 200)];
		co2.backgroundColor = [UIColor redColor];
		[self addSubview:co2];
		
	}

	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (CGSize)idealContentSize {
	return CGSizeMake(2000, 2000);
}

@end
