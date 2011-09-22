//
//  SearchResultsViewController.m
//  TwitSearch
//
//  Created by slader on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "JSONKit.h"
#import "WebViewController.h"
#import "TwitTableViewCell.h"

@interface SearchResultsViewController()

@property (nonatomic, retain) NSArray *twits;

@end

@implementation SearchResultsViewController

@synthesize searchTerm = _searchTerm;
@synthesize twits = _twits;
@synthesize operationQueue = _operationQueue;

- (void)dealloc
{
    self.twits = nil;
    self.searchTerm = nil;
    self.operationQueue = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) getTwits
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     }];
    
    NSString *urlString = [[NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", self.searchTerm] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *JSONString = [[NSString alloc] initWithContentsOfURL:url];
    
    if ([JSONString length] == 0)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error retrieving your twits" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release]; alertView = nil;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         }];
    }
    else
    {
        NSDictionary *JSONData = [JSONString objectFromJSONString];
        
        self.twits = [JSONData valueForKey:@"results"];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
         {
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             [self.tableView reloadData];
             [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
         }];
    }
    
    [JSONString release]; JSONString = nil;
}

- (void) refreshTwits
{
    [self.operationQueue addOperationWithBlock:^{
        [self getTwits];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTwits)] autorelease];
    
    self.title = self.searchTerm;
    
    if (!self.operationQueue)
    {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 2;
    }
    
    [self refreshTwits];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.twits count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TwitTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *twit = [self.twits objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"@%@", [twit valueForKey:@"from_user"]];
    cell.detailTextLabel.text = [twit valueForKey:@"text"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *twit = [self.twits objectAtIndex:[indexPath row]];
    NSString *text = [twit valueForKey:@"text"];
    NSString *userName = [twit valueForKey:@"from_user"];
    
    CGSize boundingSize = CGSizeMake(self.tableView.frame.size.width-40, CGFLOAT_MAX);
    
    CGFloat detailHeight = [text sizeWithFont:[TwitTableViewCell detailFont] constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap].height;
    CGFloat textHeight = [userName sizeWithFont:[TwitTableViewCell textFont] constrainedToSize:boundingSize lineBreakMode:UILineBreakModeWordWrap].height;
    
    return detailHeight + textHeight + 10;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *twit = [self.twits objectAtIndex:[indexPath row]];
    NSString *fromUser = [twit objectForKey:@"from_user"];
    NSString *idString = [twit objectForKey:@"id_str"];
    NSString *url = [NSString stringWithFormat:@"http://www.twitter.com/%@/status/%@/", fromUser, idString];
    
    WebViewController *webViewController = [[WebViewController alloc] init];
    webViewController.url = [NSURL URLWithString:url];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release]; webViewController = nil;
}

@end
