//
//  DocumentTableViewCell.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/13/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DocumentTableViewCell : UITableViewCell {
	UILabel *title;
	UIImageView *imageView;
	UILabel *created;
	UILabel *saved;
}

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *created;
@property (nonatomic, retain) IBOutlet UILabel *saved;

@end
