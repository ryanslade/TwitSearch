//
//  SearchResultsViewController.h
//  TwitSearch
//
//  Created by slader on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchResultsViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, retain) NSString *searchTerm;

@end
