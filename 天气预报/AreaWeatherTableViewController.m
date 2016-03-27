//
//  AreaWeatherTableViewController.m
//  天气预报
//
//  Created by doubi on 16/2/25.
//  Copyright © 2016年 doubi. All rights reserved.
//

#import "AreaWeatherTableViewController.h"

@interface AreaWeatherTableViewController ()

@end

@implementation AreaWeatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=[self.city cityname];
    [self getWeatherInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getWeatherInfo
{
    areas=[[NSMutableArray alloc] init];
    
    NSString  *webPath=[NSString stringWithFormat:@"http://flash.weather.com.cn/wmaps/xml/%@.xml",[self.city pyName]];
    NSURL  *url=[NSURL URLWithString:webPath];
    
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask  *task=[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error)
        {
            NSLog(@"网络错误....");
            return;
        }
        
        NSXMLParser  *xmlParser=[[NSXMLParser alloc] initWithData:data];
        xmlParser.delegate=self;
        [xmlParser parse];
    }];
    //start
    [task resume];
}
#pragma    mark --xml代理
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    [areas removeAllObjects];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"city"])
    {
        area=[[AreaWeather alloc] init];
        
        NSArray  *allkey=[attributeDict allKeys];
        for(NSString  *key in allkey)
        {
            [area setValue:[attributeDict objectForKey:key] forKey:key];
        }
        [areas addObject:area];
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"数据解析错误.");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return areas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    AreaWeather  *temp=[areas objectAtIndex:indexPath.row];
    cell.textLabel.text=temp.cityname;
    
    NSString  *info=[NSString stringWithFormat:@"%@ : %@ [%@~%@]",temp.stateDetailed,temp.temNow,temp.tem1,temp.tem2];
    cell.detailTextLabel.text=info;
    cell.detailTextLabel.textColor=[UIColor blueColor];
    
    cell.imageView.image=[self.weatherImage objectForKey:temp.state1];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isCanForward==NO){
        return;
    }
    
    AreaWeather  *selectedCity=[areas objectAtIndex:indexPath.row];
    
    UIStoryboard  *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AreaWeatherTableViewController  *view=[storyBoard instantiateViewControllerWithIdentifier:@"areaSeg"];
    view.weatherImage=self.weatherImage;
    view.city=selectedCity;
    view.isCanForward=NO;
    //跳转
    [self.navigationController pushViewController:view animated:YES];
}


@end
