//
//  ConceptObjectColorChooserViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/24/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "ConceptObject.h"

@interface ConceptObjectColorChooserViewController : UITableViewController {
	ConceptObject *conceptObject;
}

@property (nonatomic, retain) ConceptObject *conceptObject;

@end
