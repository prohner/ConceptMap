//
//  ConceptObjectFontChooserViewController.h
//  ConceptMap
//
//  Created by Preston Rohner on 10/3/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConceptObject;

@interface ConceptObjectFontChooserViewController : UITableViewController {
	ConceptObject *conceptObject;
	UIView *tableHeaderView;
	NSArray *fontsArray;
	NSIndexPath *checkedIndexPath;
}

@property (nonatomic, retain) ConceptObject *conceptObject;
@property (nonatomic, retain) NSArray *fontsArray;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;

- (IBAction)makeFontSizeBigger:(id)sender;
- (IBAction)makeFontSizeSmaller:(id)sender;
- (void)stepFontSize:(int)direction;

@end
