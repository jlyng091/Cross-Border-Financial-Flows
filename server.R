
shinyServer(function(input, output, session){
    gdp_comp <- reactive({
      gdp_normalised %>% filter(Balance.sheet.position == input$position & L_DENOM == input$currency) %>%
        select(Counterparty.country, "basis_points" = matches(paste0("X", as.character(input$year), ".Q4")))
    })
    
#### Reformatting time-series data for normal plots
    abs_stocks <- reactive({
      counterparties.df %>% filter(Counterparty.country == input$countries & L_DENOM == "USD") %>% 
        gather(key = "Quarterlies", value = "Stock.outstanding", -c(1:4)) %>% 
        mutate(Quarterlies = as.character(gsub("X", "", Quarterlies))) %>%
        spread(Balance.sheet.position, Stock.outstanding)
    })
    
#### Computing the accummulated financial stocks normalised by ongoing GDP
    relative_stocks <- reactive({
      gdp_normalised %>% filter(Counterparty.country == input$countries & L_DENOM == "USD") %>% 
        gather(key = "Years", value = "Stock.relative", -c(1:3)) %>% 
        mutate(Years = as.numeric(gsub("X|Q", "", Years))) %>% 
        spread(Balance.sheet.position, Stock.relative)
    })

#### Text elements for motivation page
    output$impetus = renderUI({
      lede <- ('Hurricane Sandy. Goldman Sachs alit. Our beacon of civilisation, 
           powered by backup generators too big to fail in a capitalocenic sea of darkness.')
     
      background <- ('Our world financial system exerts influence in myriad unseen ways.
                     Proffers cheap credit for job creation. Directs flows of capital
                     to promising new sources of innovation and consumption. Transmits
                     conditions of general economy beyond national borders, pooling the risks
                     and the gains. Its sinews underwrite present-day prosperity \u2014 
                     and heightens our insecurities.')
      
      prospectus_1 <- ('When in 2007 this fundamental plumbing of world economy was clogged, 
                      unprecedented actions undisclosed to the democratic public were 
                      undertaken by the US Federal Reserve. $6.18T in short-term dollar 
                      loans were extended to banks globally to keep the world economy on 
                      life support.')
      
      prospectus_2 <- ('It was an extraordinary reinforcement of dollar supremacy. For the first time,
                      economists were alerted to the quintessence of cross-border dollar loans in
                      the new, post-2000s economic order of truly global banking.')
      
      prospectus_3 <- ('This project purports to cursorily examine the entanglement of 
                       cross-border dollar loans since the Volcker Revolution of 1979, which marks the 
                       emergence of modern finance.')
                     
      HTML(paste(lede, background, prospectus_1, prospectus_2, prospectus_3, sep = '<br/><br/>'))
    })

#### Thorough geo-chart
    output$detailed_globe = renderGvis({
      gdp_comp1 = gdp_comp()
      gvisGeoChart(
        data = gdp_comp1,
        locationvar = "Counterparty.country",
        colorvar = "basis_points",
        hovervar = "Counterparty.country",
        options  = list(region = "world", 
                        displayMode = "regions",
                        colorAxis = "{minValue: 0, maxValue: 5000, colors: ['#a0f13b', '#ef394b']}",
                        backgroundColor = "#f7e8dc",
                        datalessRegionColor = "#f7e8dc",
                        width = "1220", height = "450",
                        keepAspectRatio = TRUE)        )
    })

#### Interactive line chart displaying dollar-denominated claims and liabilities over time
    output$strategic_countries = renderGvis({
      abs_stocks_1 = abs_stocks()
      gvisLineChart(
        data = abs_stocks_1,
        xvar = "Quarterlies",
        yvar = c("Claims", "Liabilities"),
        options=list(title="Core Countries of World Economy",
                     titleTextStyle="{color:'black',
                        fontName:'Helvetica',
                        fontSize:16}",
                     curveType="function", 
                     vAxes="[{title:'Absolute Value (millions)',
                        titleTextStyle: {color: 'blue'},
                        textStyle:{color: 'blue'},
                        textPosition: 'out'}]", 
                     hAxes="[{title:'Year',
                        format:'####',
                        textPosition: 'out'}]",
                     width=1250, height=500,
                     backgroundColor = '#f7e8dc',
                     animation.startup = TRUE,
                     animation.duration = '10'))
    })

#### Text elements for the conclusion page
    output$merkel = renderUI({
        HTML('“We do live in a democracy and we are pleased about that. 
                    It is a parliamentary democracy. That means that the budget 
                    is a key prerogative of parliament. Thus we will find ways to 
                    organize parliamentary codetermination <b>in such a way that it is 
                    nevertheless market conforming</b>, so that the appropriate signals 
                    appear in the markets. I hear from our budget specialists that 
                    they are conscious of this responsibility.” \u2014Angela Merkel, 2011')
    })
    
    output$findings = renderUI({
        finding_1 <- ('We superficially demonstrate the extent to which modern financial flows 
                  are truly interconnected. The topological structure of world finance continues to 
                  evolve as all systems do, but the monitoring of unprecedently large balance 
                  sheets across global banks is undisputedly a key feature to crisis avoidance. 
                  The data collected by the Bank of International Settlements, though incomplete 
                  and anonymised in aggregate, is nevertheless first-class for this sort of work.')
        
        finding_2 <- ("Had we more time, the natural extension of the current project would be a 
                      network analysis of regional and national banking flows. This would require
                      thorough detective work in segmenting and aggregating flow patterns.
                      To further demonstrate the depth of the dataset, one may break 
                      down financial claims by a) aggregated economic actors and b) currency
                      exposures to roughly estimate the shortfall in dollar-funding on banks' balance 
                      sheets, as necessary to maintain solvency in times of general crisis.")
                      
        finding_3 <- ('One could, along those lines, estimate risk exposures of regional banking sectors 
                      to an appreciation of the US dollar on foreign exchange markets. This could   
                      extend into an estimation of the extent to which a cascading loss of access 
                      to US-dollar assets on short-term funding markets, perhaps as a result of US 
                      domestic political risk, could precipitate general economic collapse.')
                      
        finding_4 <-  ('Alternatively one could, with the diversity of options in this dataset, conduct a 
                      sectoral analysis of viable banking businesses according to basic constraints in 
                      the global economic environment, including the competition posed by other large global banks.')
                  
        finding_5 <-  ('Academic curiosity aside, all citizens would benefit from a better understanding of
                      global financial topology. It shapes the conditions, however subtly, by which we live 
                      our ordinary lives, from the prices we pay, to the credit we use, to our general chances of 
                      employment and particularly the extent of democratic choice in the societies we live. For as 
                      Chancellor Merkel notes, there are very real tradeoffs to be made and negative shocks to our
                      livelihoods avoided \u2014 if only we were literate in the art of political economy.')
        
        link_1 <- ('The full dataset can be found here. 
                   <https://stats.bis.org/#ppq=LBS_DE_BANKS_IN_ALLRC_XB_C_L;pv=2,9~1,12~/>')
      
        HTML(paste(finding_1, finding_2, finding_3, finding_4, finding_5, link_1, sep = '<br/><br/>'))
    })
    
    output$author = renderUI({
        HTML('The author, Justin L. Ng, is a student of the NYC Data Science Academy, where he is presently engaged 
              in deep-seated effort to enhance his analytic toolkits. He is a graduate of Rice 
              University, where he studied economics and engineering, and of the Collegiate School.')
    })
})
      
