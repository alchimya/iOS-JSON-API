//
//  ViewController.m
//  ObjC-JSON-API
//
//  Created by Domenico Vacchiano on 07/11/15.
//  Copyright © 2015 DomenicoVacchiano. All rights reserved.
//

#import "ViewController.h"

#define kTagLabelName  1
#define kTagLabelUrl  2

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong)NSArray*ds;
@end

@implementation ViewController

#pragma mark View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.activityIndicator.hidden=true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark IBAction(s)
-(IBAction)sendWebRequest:(id)sender{
    
    //sends a request
    [L3SDKJWARequest sendTo:@"https://api.github.com/users/alchimya/repos"
            withMethod:HTTPRequestMethodGet
             andParams:nil andDelegate:self];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityIndicator.hidden=false;
        [self.activityIndicator startAnimating];
    });
}
#pragma mark JWA callbacks

-(void)L3SDKJWARequestDelegate_Response:(id)response{

    //web data response presentation
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSLog(@"jsons response has a dictionary format");
        
    }else if ([response isKindOfClass:[NSArray class]]) {
        dispatch_async(dispatch_get_main_queue(),^{
            self.ds=response;
            [self.tableView reloadData];
            self.activityIndicator.hidden=true;
            [self.activityIndicator stopAnimating];
        });

    }
    
    //NSLog(@"%@",response);
}
-(void)L3SDKJWARequestDelegate_Error:(NSError*)error{
    NSLog(@"%@",[error localizedDescription]);
    self.activityIndicator.hidden=true;
    [self.activityIndicator stopAnimating];
}

#pragma mark TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ds.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel*lName=(UILabel*)[cell viewWithTag:kTagLabelName];
    UILabel*lUrl=(UILabel*)[cell viewWithTag:kTagLabelUrl];
    
    NSDictionary*repo=self.ds[indexPath.row];
    if (repo) {
        lName.text=[repo objectForKey:@"name"];
        lUrl.text=[repo objectForKey:@"url"];
    }
    
    return cell;
}

@end
