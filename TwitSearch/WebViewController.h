//
//  WebViewController.h
//  TwitSearch
//
//  Created by slader on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController {
    
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
