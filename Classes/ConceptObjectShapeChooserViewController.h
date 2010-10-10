//
//  ConceptObjectShapeChooserViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/9/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@class ConceptObject;

@interface ConceptObjectShapeChooserViewController : UITableViewController {
	ConceptObject *conceptObject;
	int originalHeight;
	int originalWidth;
}

@property (nonatomic, retain) ConceptObject *conceptObject;

@end
