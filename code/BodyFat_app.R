# model BODYFAT ~ ABDOMEN + HEIGHT + WRIST +AGE
# unit lb and cm
library(shiny)
library(ggplot2) 

ui <- fluidPage(

    # Application title
    titlePanel(strong("Body Fat Calculator")),
    

    # Sidebar with a slider input for number of bins 
    sidebarLayout(position = "left",
                  sidebarPanel(
                      radioButtons("Lengthunit", "Lenth Units Preference:", list("cm" = "cm","inch" = "inch")),

                      numericInput("Abdomen", "Abdomen Circumference:", min = 20, max = 200, value = NA),
                      helpText("Your Abdomen Circumference should be between 20 to 200cm"),

                      numericInput("Height", "Height:", min = 140, max = 220, value = NA),
                      helpText("Your Height should be between 140  to 220cm"),
                      
                      numericInput("Wrist", "Wrist Circumference:", min = 10, max = 35, value = NA),
                      helpText("Your Wrist Circumference should be between 10 to 35cm"),
                      
                      # numericInput("Age", "Age:", min = 15, max = 100 , value = NA),
                      # helpText("Your Age should be between 15 and 100"),

                      # selectInput("Gender", "Gender:",list("Man" = "Man","Woman" = "Woman")),
                      helpText(strong("We are sorry that our model is  more suitable for mans")),
                      
                      actionButton("calculate",label = "Go!",icon=icon('angle-double-right'),class = "btn-success")
                  ),
                  mainPanel(h1("Introduction And Background",style = "font-size:120%"),
                            htmlOutput("Introduction"),
                            h1("Your body fat percentage is:",style = "font-size:120%"),
                            textOutput("results"),
                            tags$head(tags$style("#results{color: red;
                                 font-size: 120%;
                                 font-style: italic;
                                 }"
                            )
                            ),
                            plotOutput(outputId="PiePlot"),
                            h1("The American Council on Exercise Body Fat Categorization:",style = "font-size:120%"),
                            tableOutput("AC"),
                            h1("Contact Information",style = "font-size:120%"),
                            htmlOutput("ContactInformation")
                  )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
    # model BODYFAT ~ ABDOMEN + HEIGHT + WRIST +AGE
    # unit lb and cm
    
    OutType <- eventReactive(input$calculate,{
        
        # OriginData=c(input$Abdomen,input$Height, input$Wrist, input$Age)
        OriginData=c(input$Abdomen,input$Height, input$Wrist)
        # change input data unit
        if(input$Lengthunit=="inch"){
            OriginData=OriginData*2.54
        }else{
            OriginData=OriginData
        }
        
        # calculate boda fat percentage
        lm=c(11.12688,0.71369,-0.16477,-1.57409)  #duzi shengao shouwan
        d = c(1,OriginData)
        bodyfat=as.numeric(round(lm%*%d,digits = 1))
        
        
        if (is.na(d[2]) == TRUE | is.na(d[3]) == TRUE|is.na(d[4]) == TRUE){
            OutType = 'A'         #empty data
        }
        else if (d[2] < 20 | d[2] > 200){
            OutType = 'B'       
        }        
        else if (d[3] < 140 | d[3] > 220){
            OutType = 'C'      
        }
        else if (d[4] < 10 | d[4] > 35){
            OutType = 'D'     
        }
        # else if (d[5] < 15 | d[5] > 100){
        #     OutType = 'E'     
        # }    # age
        else if(bodyfat<0 | bodyfat>50){
            OutType = 'F'             
        }
        else{
            OutType = bodyfat
        }
        OutType
    })
    
    output$results <- renderText({
        input$calculate
        if(OutType()!='A' & OutType()!='B' & OutType()!='C' & OutType()!='D' & OutType()!='E' &OutType()!='F'){
            bodyfat=OutType()
            paste(bodyfat,"%")
        }
        else if (OutType() == 'A'){
            paste("Please input your data")
        }
        else if (OutType() == 'B'){
            paste("Please input a value in the limited range. Your Abdomen Circumference should be between 20 to 200cm")
        }
        else if (OutType() == 'C'){
            paste("Please input a value in the limited range. Your Height should be between 140  to 220cm")
        }
        else if (OutType() == 'D'){
            paste("Please input a value in the limited range. Your Wrist Circumference should be between 10 to 35cm")
        }
        # else if (OutType() == 'E'){
        #     paste("Please input a value in the limited range. Your Age should be between 15 and 100")
        # }
        else if (OutType() == 'F'){
            paste("It seems that the bodayfat calculated from the data you input is an extreme value, which
                  is smaller than 0% or bigger than 50%. Please check.")
        }
    })


    
    
    output$Introduction <- renderUI({
        HTML('Body fat is an important part of the human body because it has many functions, 
        such as storing energy and secreting hormones. 
        This means that body fat percentage is an important indicator of human health.
         ')
    })
    
    output$AC <- renderTable(
        web.data<-data.frame(Description=c('Essential fat', 'Athletes','Fitness','Average','Obese'),
                             #Women=c('10-13%','14-20%','21-24%','25-31%','32+%'),
                             Men=c('2-6%','6-14%','14-18%','18-25%','25+%')
        )
                             
    )
    
    output$ContactInformation <- renderUI({
        HTML('<br>
          If you have any questions, please contact: <br> 
          <br>
          Haoyue Shi hshi87@wisc.edu;
          
          Yijin Guan yjuan37@wisc.edu;
          
          Zihan Zhao zzhao387@wisc.edu;
          
          Shubo Lin slin268@wisc.edu;
         
         ')
    })
    
    output$PiePlot <- renderPlot({
        input$calculate
        if(OutType()!='A' & OutType()!='B' & OutType()!='C' & OutType()!='D' & OutType()!='E' &OutType()!='F'){
            x=OutType()
        }
        else {
            x=0
        }
            #x=OutType();
            legend=c(rep("Body Fat",10*x),rep("Non Body Fat",(1000-10*x)))
            d=as.data.frame(legend)
            blank_theme <- theme_minimal()+
                theme(
                    axis.title.x = element_blank(),
                    axis.title.y = element_blank(),
                    axis.text.x = element_blank(),
                    axis.text.y = element_blank(),
                    panel.border = element_blank(),
                    panel.grid=element_blank(),
                    axis.ticks = element_blank(),
                    plot.title=element_text(size=14, face="bold")
                )
            gg.gauge <- function(pos, breaks=c(0,2,6,14,18,25,50)) {
                require(ggplot2)
                get.poly <- function(a,b,r1=0.5,r2=1.0) {
                    th.start <- pi*(1-a/50)
                    th.end   <- pi*(1-b/50)
                    th       <- seq(th.start,th.end,length=50)
                    x        <- c(r1*cos(th),rev(r2*cos(th)))
                    y        <- c(r1*sin(th),rev(r2*sin(th)))
                    return(data.frame(x,y))
                }
                ggplot()+ 
                    geom_polygon(data=get.poly(breaks[1],breaks[2]),aes(x,y),fill="#EDF6F9")+
                    geom_polygon(data=get.poly(breaks[2],breaks[3]),aes(x,y),fill="#277DA1")+
                    geom_polygon(data=get.poly(breaks[3],breaks[4]),aes(x,y),fill="#43AA8B")+
                    geom_polygon(data=get.poly(breaks[4],breaks[5]),aes(x,y),fill="#90BE6D")+
                    geom_polygon(data=get.poly(breaks[5],breaks[6]),aes(x,y),fill="#99D98C")+
                    geom_polygon(data=get.poly(breaks[6],breaks[7]),aes(x,y),fill="#E07A5F")+
                    geom_polygon(data=get.poly(pos-0.3,pos+0.3,0.2),aes(x,y))+
                    geom_text(data=as.data.frame(breaks), size=8, fontface="bold", vjust=0,
                              aes(x=1.1*cos(pi*(1-breaks/50)),y=1.1*sin(pi*(1-breaks/50)),label=paste0(breaks,"%")))+
                    annotate("text",x=0,y=0,label=pos,vjust=0,size=15,fontface="bold")+
                    coord_fixed()+
                    theme_bw()+
                    theme(axis.text=element_blank(),
                          axis.title=element_blank(),
                          axis.ticks=element_blank(),
                          panel.grid=element_blank(),
                          panel.border=element_blank()) 
            }
            gg.gauge(x)
    })
}


# Run the application 
shinyApp(ui = ui, server = server)
