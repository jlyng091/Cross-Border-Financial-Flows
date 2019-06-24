
shinyUI(fluidPage(
    titlePanel("Cross-Border Financial Flows"),
    
#### Lays out the motivation for our data exploration
    tabsetPanel(
      tabPanel("Motivation", 
               sidebarLayout(
                 sidebarPanel(position = c('right'),
                              fluidRow(
                                box(outputId = 'introduction',
                                    width = 12,
                                    htmlOutput('impetus')),
                                    tags$head(tags$style("#impetus{font-size: 13px}"))
                 )),
                 mainPanel(
                    fluidRow(box(img(src = 'capitalocene.jpg', width = '205%', height = '505px')))
                    )
               )),
      
#### Animated world map displaying claims and liabilities as percentage of ongoing 
#### Gross Domestic Product, measured in basis points - 100th of a percentage point
      tabPanel("World View",
               mainPanel(
               fluidRow(
                 box(
                   outputId = "granularity", 
                   width = 12, 
                   htmlOutput("detailed_globe"))
               ),
               
               hr(),
               
               fluidRow(
                 column(4, 
                        sliderInput(inputId = "year", 
                                    label = "Select Year", 
                                    min = 1977, 
                                    max = 2018, 
                                    value = 2000, 
                                    step = 5, 
                                    sep = "", 
                                    animate = TRUE)),
                 
                 column(4, 
                        selectizeInput(inputId = "position", 
                                       label = "Select Balance Sheet Position",
                                       choices = positions)),
                 column(4, 
                        selectizeInput(inputId = "currency", 
                                       label = "Select Currency", 
                                       choices = currencies))
               ))
      ),

#### Line chart of USD-denominated loans taken on by strategic countries filtered from the Parents list
#### (the countries with international banking sectors)
      tabPanel("Strategic USD Flows",
        
               hr(),
               fluidRow(
                 column(4, 
                        offset = 1, 
                        selectizeInput(inputId = "countries", 
                                       label = "", 
                                       choices = strategic))
               ),
               
               fluidRow(
                 box(outputId = "strategic", 
                     width = 10, 
                     htmlOutput("strategic_countries")))
               ),

#### Text write-up of project and future implications
      tabPanel("Conclusions",
               hr(),
               titlePanel(
                    fluidRow(
                      # tags$style(HTML(".box.box-solid.box-primary>.box-header {
                      #   }
                      #   .box.box-solid.box-primary{
                      #   background:#f7e8dc
                      #   }"
                      # )),
                        column(6, offset = 3,
                               box(outputId = 'trilemma',
                                    width = 12,
                                    status = "primary",
                                    solidHeader = TRUE,
                                    htmlOutput('merkel'),
                                    tags$head(tags$style("#merkel{color: green;
                                                font-size: 11px;
                                                font-style: italic}"))
                               ))
                     )),
               hr(),
               mainPanel(
                    fluidRow(
                      column(12, offset=3,
                             box(outputId = 'summary',
                                    width = 12,
                                    htmlOutput('findings')),
                                    tags$head(tags$style("#findings{font-size: 13px}"))
                      ))
               )),

#### Brief record of the author
      tabPanel("Author",
               hr(),
               fluidRow(
                 column(12, offset=5,
                        box(img(src = 'self.jpg', width = '33%', height = '200px')))),
               hr(),
               mainPanel(
                 fluidRow(
                   column(11, offset=4,
                          box(outputId = 'self',
                              width = 12,
                              htmlOutput('author')),
                          tags$head(tags$style("#findings{font-size: 13px}"))
                   ))
               ))
      ))
)

