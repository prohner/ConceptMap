//
//  ConceptMapView.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ConceptObject.h"

@interface ConceptMapView : UIScrollView <UIScrollViewDelegate> {

}

- (CGSize)idealContentSize;

@end
