<p style="text-align: center;">**Exploring War, Decolonization, and Factors of Independence**</p>
<p style="text-align: center;">Abigail Weinstein</p>
<p style="text-align: center;">PLSC 497.2 Final Report</p>    
<p style="text-align: center;">December 15, 2025</p>    

During the "Age of Discovery", what we have now come to know as European colonialism began to take shape. With Portugal's initial exploration and eventual settlement of the north and west of Africa, the age of cross-continental movement and conquest fell to the promise of what lay beyond the European coastline. Motivated by new markets, trade routes, and sources of wealth, the major European empires began moving forward with trans-oceanic travel in search of territories to lay stake to (5). Soon, a "civilizing" mission began to take shape and settlement became not only a means to establish markets, but to proselytize as well. While this became practice in North and Western Africa, the "Age of Discovery" and European imperialism truly gained momentum with Christopher Colombus' "discovery" the Americas on his voyage to India. In the two centuries that followed, Europe transformed from a relatively isolated cluster of nations to group of constantly warring global empires, with territories spanning from Canada to the Philippines and everywhere in between. In the 19th century, new empires rose to overtake the declining European powers, taking their colonies and establishing new ones. Six centuries later, though, we see very few of these colonies remaining. There are a few exceptions - the United State's Guam and France's French Polynesia - but the extremely colonized world is now largely independent (6). 

Decolonization did not happen overnight, nor is it a universal process. But there are a number of trends within the phenomenon. There are instances of gradual, peaceful transitions of power and central governance to the colonies themselves. A prime example of this was the decades long transition of Canada from a colony of Britain to a sovereign state via the British North America Acts. Britain followed a similar process with its settlements in Australia. For many states, though, this is not the path towards independence - its often violent. Colonialism itself is violent in nature, so it follows that the process of escaping that would require some degree of violence in return. Tensions between ideas of autonomy, a need for economic and personal security, and the persistent existence in an inherently violent system can result mobilization and outcry. It is in moments like these that there is a propensity towards insurgency, rebellion, and even war (7). This was the case during the American Revolution and it continues to be the case well into the modern age. 

There exists full bodies of literature surrounding imperialism and decolonization. From accounts of colonial histories and empire collapse to the analysis of the long-lasting legacies of decolonization both domestically and internationally, the processes and impacts of decolonization are incredibly relevant and well-documented. A common piece of discussion is that of the violence of decolonization and wars of independence. With this, we enter this discussion and provide a quantitative approach to the process of decolonization and the influence of war on independence. While there are many successful stories of wars for independence, it is not uncommon to find instances of failure among these narratives. Does engaging in war contribute to an increased likelihood of independence? Or is it a result of weakening and overwhelmed colonizing states that lead to independence?

To address this question, we will create three predictive models relating  involvement in war to events of decolonization. To do so, we have developed a dataset that synthesizes data compiled by Varieties of Democracy (1) and Correlates of War (2), Bastian Becker (COLDAT) (3), and Andreas Wimmer (4). The resulting dataset logs detail on colonial occupation, war involvement, demographics, geography for over 120 colonies from 1817 to 1989. Detailed explanation of the dataset can be found in Table 1 in the appendix of this report. Using this information, we will be able to create models of independence and determine the extent to which war and conflict leads to the establishment of a sovereign state. 

### Literature Review and Model Explanations
There is more to understanding war in relation to decolonization - and decolonization in general - than simply observing that there seems to be a relationship between colonial combat and independence. This is, in part the basis for our examination of the two, but it is important to understand the nuances of the topic and one impacts the other from a theoretical perspective. In this report, we are examining three primary models with three distinct primary predictive variables. The first serves as a base model; it simply examines if involvement in any kind of armed combat in the year prior leads to decolonization. The second model narrows in on this, asking whether the *type* of war and political conditions lead to independence. The third model diverges from the colony perspective and focuses on the colonizer, asking if excessive conflict elsewhere leads to decreased importance of colonial retainment. In addition to the primary predictive measures, we also opt to incorporate additional control and secondary predictor measures to address other components of the surrounding theoretical discussion. 

#### Colony War Model
The "Colony War" model is the first and simplest model developed to address the effect of war on decolonization. 
\[
\text{Decolonization} = \beta_{\text{a}}\text{War} + \beta_{\text{b}}ln\text{(pop)} + \sum(\beta *\text{region})
\]
We are, of course, including war as the primary predictor in this model. War, for the purposes of this analysis, adheres to the Correlates of War definition of war - "sustained combat, involving organized armed forces, resulting in a minimum of 1,000 battle-related fatalities" (8). This helps differentiate wars from skirmishes and other violent episodes that may occur within a country. However, in this model, we are not just assessing a particular category of war (this will be addressed later), but rather the entire concept of war. Wars motivated by a desire for independence are included in this, but the broader conception is just as important. Much of the discussion surrounding war in relation to decolonization that is \textit{not} situated around wars of independence is tied to World War II. Post-World War II, the framework of international relations and foreign policy was fundamentally altered, pivoting from a narrative of domination to one of democracy. This is, in all likelihood, a direct result of Europe's subjugation to the same policies they had been engaging in for centuries at the hand of the Axis powers during the war. While the remaining colonial powers may not have initially thought of this in the context of their own territories, the creation of the United Nations (UN) certainly extended it to them. The "principle of self-determination" became the line of the UN (9, 10). This, paired with the use of colonies in war time and the collapse of multiple empires during those engagements, leads to the speculation that general involvement in war may lead to independence in one way or another. Post-conflict periods often are those of political upheaval and re-evaluation. Even if this were not the case, there was also a significant increase in a desire of independence among remaining colonies after this period - especially in those that fought (10). Further thought brings us to the assumption that engagement in war, especially a more globalized conflict like World War II, enhances the realization of a colony's ability to mobilize military and act independently of or against their colonial power.

In addition to this primary variable, we also need to address confounding effects, namely population and region. These will be included in every model as a form of control variable. Literature suggests that population trends play a significant role in movements towards independence and revolution (11, 12). Rapid population growth is often associated with fewer economic opportunities for that generation as they reach adulthood. Jack Goldstone states that, while war and international instability are not often a *direct* result of population changes in the labor market, "...in those contexts where population changes produce domestic political crises, the risk of international war is also increased" (12). There are also ties to growing populations and conflict through expanded resource needs and lack of cooperation from ruling elites (12). Youth bulges are also associated with developments in more radical ideologies within those populations (12, 13). In any case, there are multiple ties to population change and a likelihood for political violence and regime changes. We have seen evidence of this throughout history, not just in the modern age. As such, it is important to control for such factors. 
We also introduce geopolitical region as a control factor within these models. As provided by Varieties of Democracy (V-DEM) (1), I condensed my data into five geopolitical regions: Latin America, Europe, the Middle East, Sub-Saharan Africa, and Asia. This reorganization has methodology-relevant justification, but the inclusion of region overall is essential. There have been repeated instances of political domino effects throughout regions. This is not isolated to just colonization and decolonization, as indicated by the existence of "Domino Theory" in reference to communism spreading throughout Southeastern Europe. In the context of colonialism though, we see this in the rapid decolonization of South America, with a majority of the region earning independence from colonial powers in the first twenty years of the 19th century. Recent research has even applied the geopolitical domino effect to independence events in Eastern Europe during the Cold War (14). 

#### Colony War Motivations Model
The second model is our "Colony War Motivations" model. This model expands upon the first, exchanging a rudimentary binary analysis of war for a more in-depth approach to war and its motivations. To do so, we incorporate colonizer democracy scores, as calculated by V-DEM$^{1}$, into our model and pair it with a categorical approach to the *type* of war colonies engage in. 
\[
\text{Decolonization} = \sum(\beta*\text{war type}) + \beta_{\text{b}}\text{democracy + } \beta_{\text{c}}ln\text{(pop)} + \sum(\beta *\text{region})
\]
These modifications tie into discussions specifically about wars of independence. In addition to a binary measure of war, we also have a categorical measure of war provided for by the Correlates of War dataset (4). This measure accounts for interstate wars, intrastate (civil) wars, and extra-state wars. Interstate wars (1), per COW, are international wars between at least two state actors (8). Intrastate wars (3) encompass civil wars and wars with regional governments. *Extra-state* wars (2) are the most relevant to our discussion. These are are wars that take place between a state and a non-state power. Within this category, COW places both wars of imperialism and wars of independence. While there are theoretical supports for war in general to generate independence and/or independence movements within a colony, it is more logical to conclude that wars engaged in with the expressed purpose of obtaining independence or otherwise revolting against a colonial power will end with independence. 

Level of democracy of the colonizing power is also included within this model of war motivations. Calculated by V-DEM, this measure synthesizes metrics of executive power, equal rights, and electoral components to determine whether or not a country at a given time is considered to be "democratic". We include this metric for a variety of reasons. First, there is some evidence that if an imperial power is democratic, there is a lower probability that they will go to war over threats of independence (15). Other research suggests that this is isolated over specific periods of the colonial-imperial-postcolonial sequence, suggesting that democracy actually increased warfare with colonies during the imperial period (1870 - 1945), but decreased chances of it in the post-colonial period.$^{16}$. This is relevant to our analysis, as it spans both of these periods. This, of course, is not necessarily a motivator of war for the colonies themselves though. That comes into play when democracy levels in the imperial power are lower. As previously established, colonization is an inherently violent and undemocratic practice. It follows, then, that more oppressive, less democratic regimes of the controlling state would increase not only a stronger desire for independence, but also an acclimation of the population towards violence in general. This then, presumably, would lead towards a consolidated and supported effort towards independence through any means necessary. 

#### Colonizer War Model
Finally, we have the "Colonizer War" model. This model approaches decolonization and war through the perspective of the colonizer and asks if, given the additional stressors of war, it is reasonable to maintain a colony. 
\[
\text{Decolonization} = \beta_{\text{a}}\text{War} + \beta_{\text{b}}ln(\text{coast)} + \beta_{\text{d}}ln(\text{mnt}) +\beta_{\text{c}}ln\text{(pop)} + \sum(\beta *\text{region})
\]
This model approaches justification of colonial maintenance through the perspective of resources. Colonies were, at least for a time, a source of new markets, trade, and natural resources. In the imperial era, they were viewed as strategic acquisitions, as locations for expanding military power. All these components were tied to geography in some capacity. Establishing trade necessitated ports and water access. Arable land and space for settlement and establishing bases were also beneficial for colonizers to have in a colony. Generally speaking, resource availability and these geographic components act as motivators to retain a colony and are often centered in discussions of independence (17). What does this have to do with war? Research suggests that during periods of conflict, reduction of available resources to imperial powers *also* reduces the capacity of that power to support its colonies (18). Within this discussion, there is the idea of colony retention due to access to additional resources. which is where this trade off comes into play. Increased warfare leads to reduced resources. If a colony has limited resources itself to provide to its colonizer, it is not in the colonizers interest to support that state during that period. It should be noted that this is not a trend that continues - imperial behaviors accelerate in the post-war period due to changes in power structures at the global scale (18).

### Data Description
With an understanding of why each model is relevant to the overall discussion of the relationship between war and decolonization, we can now move to more detailed analysis of the data itself. Our dataset, described in Table 1 (Appendix), has a total of 14,635 unique observations of 128 colonies across the world from 1817 to 1989. Each observation corresponds to a specific colony in a particular year during the period which they are a colony. Most countries are only in the dataset for one span of time, but there are a few instances, such as in the case of Jordan, where they do re-enter the dataset due to recolonization. The dataset identifies country and colonizer, the years of colonization, demographic, geographic, and war data points within each observation. Each observation has a decolonization and war flag to identify whether there is ongoing colonization and conflict. A screen capture of the dataset is shown in Figure 1. A full summary of primary variables within the data can be found in the appendix in Table 2. It should be noted that the war flag - and all other predictive variables - are lagged by one year. When we create the models, then, we are analyzing the chance of decolonization based off of the previous year's events and data. Other variables within the dataset, such as region and land area, are constant across the entire period a country is in the panel. 

\begin{figure}[h!]
    \centering
    \includegraphics[width=0.8\linewidth]{Screenshot 2025-12-14 205341.png}
    \caption{Screen Capture of War-Colony Dataset}
\end{figure}

There are additional nuances in data construction. Due to the need for singular observations per year, there were numerous instances where data related to our predictor variables needed to be condensed. This is specifically in reference to the war type variable. In instances where this was necessary, the category with the most instances of war in a country was selected to represent that particular yearly observation. Missingness in the data, particularly for population, was addressed via linear interpolation (19) It was imperative that as much missingness was removed from the data as possible in order to have working models. Both our explanatory and outcome variables are incredibly rare within the data set, which necessitates as many observations as possible to obtain useful results. 

\begin{figure}[h!]
    \centering
    \includegraphics[width = 1\linewidth, trim = 0 11cm 0 2cm, clip]{Visuals/outcomesum.png}
    \caption*{Table 3: Predictor and Outcome Means}
\end{figure}

We can see this rarity exemplified in Table 3. While there are over 14,000 observations of each variable, there are significantly less where an event is flagged as occurring. While our colonization war metric is, relatively speaking, prominent within the data, occurring half of observations, the remaining predictive variables and outcome variable are decidedly not. The other predictor variables have 5% of observations recording a war event of some kind. Of the 128 countries within the dataset, there are only 109 independence events recorded. Less than 1\% of the data records an instance of our outcome variable, with a baseline rate of decolonization across the data sitting at .0074. Ideally, this threshold would be closer to 3% (.03). Regardless, the data is viable. Preliminary t-test indicate that there is a substantial difference between frequency of decolonization events across observations where the colonies engage in war (.034) and those that do not (.005). 
 
Of additional importance is where the variation is coming from our data, specifically in the outcome variable. Given that most country groups only contain one instance of independence, it is expected that variation between and within groups will be comparable for this variable. The same cannot be said for the war variables. We anticipate to see greater variation between colonies in the colonizer war variable, as this behavior is not isolated to the colony itself, but spread across the handful of colonizers represented in the dataset. To determine how data is dispersed across observational groups, we calculated the within-between variance ratio, calculated by the formula below: 
\[
\text{Variance Ratio} = \frac{\sigma_{\text{within}}}{\sigma_{\text{between}} + \sigma_{\text{within}}}
\]
Table 4, in the appendix, contains the resultant ratios and variances. As expected, both decolonization and war events are fairly evenly dispersed across and within colonies, with within-variance ratios between .55 and .64. Colonizer war events, however, are dispersed more broadly across the dataset than within a particular colony group, as indicated by a variance ratio of .36. This, again, is expected, considering the nature of the variable. 

Before we move to exploring the methods, we should expand upon the relationship between our predictive variables and the outcome variable. Figures 2(a) and 2(b) show the variation of the two predictive variable clusters (colony war and colonizer war) over time with the variation of decolonization events. Because of the sheer number of colonizer war events, it is difficult to glean any true understanding from the plot beyond the spike in decolonization events in the 1960s coinciding with a steep drop colonial warfare. However, Figure 2(a) gives us a very clear image of the relationship between colony war and colony independence. While there is, again, an imbalanced relationship between the two, we do see some evidence of the measures fluctuating together, with peaks often occurring at the same points. 

\begin{figure}[h!]
\begin{center}
    \begin{minipage}[b]{0.45\textwidth} 
        \centering
        \includegraphics[width=\linewidth]{Visuals/colwar.pdf} 
        \caption*{(a) Colony Wars and Decolonization}
    \end{minipage}
    \hspace{0.05\textwidth}
    \begin{minipage}[b]{0.45\textwidth}
        \centering
        \includegraphics[width=\linewidth]{Visuals/colonizerwar.pdf}
        \caption*{(b) Colonizer Wars and Decolonization}
    \end{minipage}
    \caption{War and Decolonization Over Time}
\end{center}
\end{figure}

### Model Validation
To evaluate our three logistic regression models, will we be performing an iterated *k*-fold cross validation sequence. This method is often used to validate models without overfitting. To avoid overfitting, we train our models on a portion of the data instead of the full dataset. This leaves some data "unknown" to the model and leaves us with information to test our models on in a fashion that is more reminiscent of actual prediction. 

Non-iterated *k*-fold cross validation (CV) involves separating data into *k* random, equal groups, called "folds". We then train the model on *k*}-1 of these folds, producing coefficients for the model. Then, the trained model is fed the remaining fold and generates the probability for the outcome event occurring. This process is conducted repeatedly until all *k* folds have been in both the training and testing groups. Using an established cut-point, we can determine the accuracy of the predictions. Oftentimes, this is the mean of the outcome variable. In this case, it would be .0074. We do this through calculating the number of accurate and inaccurate predictions. These values are then turned into ratios that measure accuracy: sensitivity and specificity. Sensitivity measures the percentage of predictions the accurately predicted a "positive" event.
\[
\text{Specificity} = \frac{{\text{TP}}}{{\text{TP}} + {\text{FN}}}
\]
Specificity evaluates the same for "negative" events. 
\[
\text{Sensitivity} = \frac{{\text{TN}}}{{\text{TN}} + {\text{FP}}}
\]
An ideal model will have balanced specificity and sensitivities in addition to a high rate of model accuracy overall. 

Iterated *k*-fold cross validation (CV) follows a similar process, but instead of conducting the sequence one time, it is conducted *j* times. Each iteration of the CV sequence assigns the folds in a different, random way. At the end of this process, instead of a single probability for each observation of the dataset, there are *j* probabilities generated. These probabilities are then averaged to produce a final probability per observation that is used in the final step of validating the model. 

Instead of calculating specificity, sensitivity, and model accuracy at singular threshold as is done with singular \textit{k}-fold cross-validation, we instead plot something referred to as the "Receiver-Operator Curve" (ROC). The ROC is the predictions of probabilities generated by the iterated *k*-fold cross validation plotted at a series of different thresholds. The y-axis of this plot represents the sensitivity (true positive rate) of all predictions. The x-axis represents the false positive rate of the predictions, which is equivalent to 1 - Specificity. A well fit model will rapidly reach a high sensitivity, producing a curve that is tightly coupled with the upper left quadrant of the plot. We quantify this be calculating the area under the curve of the plotted ROC. Thus, a high AUC (.7 and greater) indicates well-fit models.

This is the process that we will be following for the three logistic regressions used to predict decolonization events. The next section displays the ROC curve, the resulting AUCs, as well as the overall model accuracy, specificity, and sensitivity statistics for the CV at the threshold of our outcome mean. 
### Results and Discussion
In our exploration of decolonization and the role war plays in its occurrence, we developed three models of prediction. These are the Colony War model, Colony War Motivation model, and the Colonizer War model.
The Colony War model explored the role of engagement in warfare played on independence the following year. The Motivation model explored this in the context of specified categories of war and overall democratization. Finally the Colonizer War model explored the role engaging in war played in retaining colonies. Each of these models were put through the iterated \textit{k}-fold cross validation process, where *k* equals 5. The sequence was iterated 10 times for each model. Table 5 shows the resultant calculations for model accuracy, sensitivity, and specificity of each model at a threshold of \textit{t} = .0074, which is the mean of our outcome variable, decolonization.

\begin{figure}[h!]
    \centering
    \includegraphics[width=1\linewidth, trim = 0 12cm 0 2cm, clip]{Visuals/modelacc.png}
    \caption*{Table 5: Model Accuracy Measures}
\end{figure}

At this threshold, we see that all of our models produce predictions that are correct at least 65% of the time. Both our Colony and Colonizer War models have lower rates of sensitivity, hovering around 58%,  indicating that they are less accurate at predicting when an independence event will occur. They are more suited for determining when one will not occur. The Colony War Motivations model, however, shows evidence of fairly well fit across the board, consistently getting over 75% predictions correct, regardless of event occurrence. 

\begin{figure}[h!]
    \centering
    \includegraphics[width=1\linewidth,trim = 0 0 0 1cm, clip]{Visuals/rocauc.pdf}
    \caption{ROC-AUC Plot of War-Decolonization Models}
\end{figure}

Preliminary investigation suggests that the models are generally well fit, especially our Colony War Motivations model. Further analysis supports this, with all models having a ROC-AUC of .65 or over. Figure 3 shows the plotted ROC curves and the model's corresponding AUC values. Most surprising is the AUC of the War Motivations model, which an AUC of .82. This not only identifies the War Motivations model as the best-fitting within the study, but very well-fitting model generally. 

All of our models suggest warfare some degree of impact on decolonization events. Further exploration of this should analyze the models themselves, not just the fit of them. This will allow us to identify exactly which components of the model are contributing most to the predictive power seen above. The general trend in measures of fit and accuracy can, in part,  almost certainly be attributed to the inclusion of population and region data across all models. These have substantial evidence supporting their relationship to political events such as decolonization. Without analyzing the models themselves, we cannot draw concrete conclusions regarding the scale of their influence comparative to our different measures of war. In any case, we can confidently conclude that colony warfare has more of an influence on colony independence in the future than colonizer war does and that, in general, war is a valid predictor, in some capacity, of whether or not a country will become independent.  












### Reference
1) Coppedge et al. (2025). V-Dem [Country-Year/Country-Date] Dataset v15. Varieties of Democracy (V-Dem) Project. https://doi.org/10.23696/vdemds25. Accessed Nov. 15, 2025. 

2) Sarkees, Meredith Reid and Frank Wayman. (2010). Resort to War: 1816 – 2007. Washington DC: CQ Press. Accessed Nov. 27, 2025.

3) Becker, Bastian. (2019). Colonial Dates Dataset (COLDAT), https://doi.org/10.7910/DVN/T9SDEW. Harvard Dataverse, V3. Accessed Nov. 21, 2025. 

4) Wimmer, A., \& Min, B. (2006). From Empire to Nation-State: Explaining Wars in the Modern World, 1816-2001. American Sociological Review, 71(6), 867–897. http://www.jstor.org/stable/25472435. Accessed Nov. 15, 2025. 

5) Paine, L. (2020). Rediscovering the age of discovery. In Jowitt, C. (Ed.), The Routledge Companion to Marine and Maritime Worlds 1400-1800, 50-66. Routledge. 

6) The British North America Acts,	SC 1974-75-76, c 53. (1975)

7) Thomas, M. (2023). Grand Narratives: Decolonisation and Its Wars. War \& Society, 42(1), 60 - 71. https://doi.org/10.1080/07292473.2023.2150480.

8) Sarkees, M. (2010). The COW Typology of War: Defining and Categorizing Wars (Version 4 of the Data). Washington DC: CQ Press.

9) Mustafa, Z. (1971). The Principle of Self-Determination in International Law. The International Lawyer, 5(3), 479-487. https://www.jstor.org/stable/40704674

10) Fisch, J. (2015). The Cold War and the Second Decolonization, 1945–1989. In The Right of Self-Determination of Peoples: The Domestication of an Illusion. Cambridge University Press.

11) Munro, D.\& Zeisberger, C. (2011). Demographics: The Ratio of Revolution. Insead.

12) Goldstone, J. (2002). Population and Security: How Demographic Change Can Lead to Violent Conflict. Journal of International Affairs, 56(1), 3-21. https://www.jstor.org/stable/24357881

13) Goldstone, J. (2021). Population, rebellion and revolution. In A Research Agenda for Political Demography, 131–145.

14) Kratovic, A. (2010). Testing for the Domino Effect of Self-Determination Movements: Montenegro, Kosovo, and the Serb Republic.

15) Goldsmith, B. E., \& He, B. (2008). Letting Go without a Fight: Decolonization, Democracy and War, 1900-94. Journal of Peace Research, 45(5), 587–611. http://www.jstor.org/stable/27640735

16) Ravlo, H., Gleditsch, N. P., \& Dorussen, H. (2003). Colonial War and the Democratic Peace. Journal of Conflict Resolution, 47(4), 520-548. doi: 10.1177/0022002703254295.

17) Norbrook, Alexander. (2025). Exploiting Natural Resources in a Decolonizing World: Evidence, Sovereignty, and Development Discourses in the UN (1951–1962). The Princeton Historical Review, 10(2). 

18) Boswell, T. (1989). Colonial Empires and the Capitalist World-Economy: A Time Series Analysis of Colonization, 1640-1960. American Sociological Review, 54(2), 180–196. https://doi.org/10.2307/2095789

19) World Population Review. (2025). Population by Country in 1800. https://worldpopulationreview.com/country-rankings/population-by-country-in-1800 

### Appendix
\begin{table}[!h]
\begin{center}
\caption{Variable Description and Sources}
\begin{tabularx}{1\textwidth}{ 
  | >{\raggedright\arraybackslash}X | >{\centering\arraybackslash}X 
  | >{\centering\arraybackslash}X | >{\centering\arraybackslash}X 
  | >{\centering\arraybackslash}X | >{\centering\arraybackslash}X |}
 \hline 
 \textbf{Variable} & \textbf{Concept Description} & \textbf{Non-Missing Observations} & \textbf{Variable Type} & \textbf{Variable Purpose} & \textbf{Source}\\
 \hline
 \hline
 \textit{country} & Colony name & 14,635 & String & ID Var. & 2 \\
 \hline
 \textit{colony COWcode} & Correlates of War country ID & 14,635 & Interval & ID Var. & 2 \\ 
 \hline
 \textit{colonizer} & Colonizer name & 14,635 & String & ID Var. & 2 \\ \hline
 \textit{colonizer COWcode} & Correlates of War country ID & 14,635 & Interval & ID Var. & 2 \\
 \hline
 \textit{yrbeg} & First year of occupation & 14,526 & Interval & - & 3, 4\\ \hline
 \textit{yrend} & Last year of occupation & 14,526 & Interval & - & 3, 4 \\
 \hline
 \textit{year} & Year of observation & 14,635 & Interval & ID Var. & - \\
 \hline
 \textit{lagyear} & Year predictor data corresponds to & 14,635 & Interval & ID Var. & - \\
 \hline
 \hline
 \textit{\textbf{decolonized}} & Flag indicating decolonization event & 14,635 & Binary & \textbf{Outcome Var.} & Author calculations \\ 
 \hline
 \textit{war} & Wartime involvement indicator & 14,635 & Binary & Predictor Var. & Author calculations \\ 
 \hline 
 \textit{wartype} & Type of war engaged in & 14,635 & Categorical & Predictor Var. & 2, 4 \\
 \hline
 \textit{colonizer warsum} & Total number of wars colonizer engaged in & 14,129 & Continuous & Predictor Var. & 2, 4; Author calculations \\
 \hline
 \end{tabularx}
 \end{center}
 \end{table}

\begin{table}[!h]
\begin{center}
\caption*{Table 1: Variable Description and Sources (Cont.)}
\begin{tabularx}{1\textwidth}{ 
  | >{\raggedright\arraybackslash}X | >{\centering\arraybackslash}X 
  | >{\centering\arraybackslash}X | >{\centering\arraybackslash}X 
  | >{\centering\arraybackslash}X | >{\centering\arraybackslash}X |}
 \hline 
 \textbf{Variable} & \textbf{Concept Description} & \textbf{Non-Missing Observations} & \textbf{Variable Type} & \textbf{Variable Purpose} & \textbf{Source}\\
 \hline
 \hline
 \textit{region} & Geopolitical area of colony & 14,635 & Categorical & Control Var. & 1; Author calculations\\ 
 \hline
 \textit{lnpop} & Colony population, logged & 14,635 & Continuous & Control Var. & 4; Author calculations \\ 
 \hline
 \textit{lnarea} & Land area in sq.km., logged & 14,635 & Continuous & Predictor Var. & 4 \\
 \hline
 \textit{lncoast} & Coastal land in km, logged & 14,635 & Continuous & Predictor Var. & 4; Author calculations\\
 \hline 
 \textit{lnmtn} & Mountainous terrain in km, logged & 14,635 & Continuous & Predictor Var. & Author calculations \\
 \hline
 \textit{colonizer demoscore} & level of democracy of colonizing nation & 13,749 & Continuous & Predictor Var. & 1 \\
 \hline
 \textit{colony} & Flag indicating colonization & 14,635 & Binary & - & Author calculations \\
 \hline
 \textit{onset} & Beginning of war flag & 14,635 & Binary & - & Author calculations \\
 \hline 
 \textit{warname} & Names of wars colony is involved in & 14,635 & String & ID Var. & 2, 3; Author calculations \\
 \hline
 \end{tabularx}
 \end{center}
 \end{table}

\begin{figure}[h!]
    \centering
    \includegraphics[width=1\linewidth, trim = 0 4.5cm 0 2cm, clip]{Visuals/sumstatsprim.png}
    \caption*{Table 2: Summary Statistics Table}
\end{figure}
\begin{figure}[h!]
    \centering
    \includegraphics[width = 1\linewidth, trim = 0 12cm 0 2cm, clip]{Visuals/outcomevar.png}
    \caption*{Table 4: Predictor and Outcome Variance}
\end{figure}
\begin{figure}[h!]
    \centering
    \includegraphics[width=0.8\linewidth, trim = 0 0 0 1.5cm, clip]{Visuals/colwar.pdf}
    \caption{Trends in Instances of Decolonization and War (A)}
\end{figure}

\begin{figure}[h!]
    \centering
    \includegraphics[width=0.8\linewidth, trim = 0 0 0 1.5cm, clip]{Visuals/colonizerwar.pdf}
    \caption{Trends in Instances of Decolonization and War (B)}
\end{figure}

\end{flushleft}
\end{document}
