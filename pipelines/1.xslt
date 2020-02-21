<!--
	This stylesheet contains the summary statistics of each trip.
	Output generated in html format
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<!--Create key to lookup the Tour information based on the TourId in the
		Trip element-->
	<xsl:key name="TripTourId" match="/Company/TourList/Tour" use="@Id" />
	<xsl:template match="Company">
		<html>
			<body>
				<br/><h1>Tour Information</h1><br/><br/>
				<!--Create table-->		
				<table width="90%" border="1">
					<tr style="background-color:gold">
						<th>Trip Id</th>
						<th>Tour</th>
						<th>Dates</th>
						<th>Duration</th>
						<th>Number of Customers</th>
						<th>Average Customer Rating</th>
						<th>Total Collections (£)</th>
					</tr>
					<!--Invoke template for each Trip-->
					<xsl:apply-templates select="TripList/Trip">
					</xsl:apply-templates>
				</table>
			</body>
		</html>
	</xsl:template>
	<!--This template will print at html row level the summary trip details and the summary statistics-->
	<xsl:template match="TripList/Trip">
		<tr>
			<td>
				<xsl:value-of select="@Id" />
			</td>
			<!--Invoke template to get Tour name-->
			<td>
				<xsl:call-template name="getTourName">
					<xsl:with-param name="pTourId" select = "@TourId" />
				</xsl:call-template>
			</td>
			<!--Print Start and End Dates of the trip -->
			<td>
				<xsl:value-of select="@StartDate" /> - <xsl:value-of select="@EndDate" />
			</td>
			<!--Invoke template to get the tour duration-->
			<td>
				<xsl:call-template name="getTourDuration">
					<xsl:with-param name="pTourId" select = "@TourId" />
				</xsl:call-template>
			</td>
			<!--Get count of customers participating in the trip-->
			<td>
				<xsl:value-of select="count(Participants/Customer)"/>
			</td>
			<!--To get the average satisfaction score sum the satisfaction score and divde my number
			of participating customers -->
			<td>
				<xsl:value-of select="sum(Participants/Customer/@SatisfactionScore) div count(Participants/Customer)"/>
			</td>
			<!--To get the total collect multiply the number of participants with the cost for the
			tour. Do a key lookup to get the tour element. -->
			<td>
				<xsl:value-of select="count(Participants/Customer) * key('TripTourId',@TourId)/TourFacts/@CostPerPerson"/>
			</td>
		</tr>              
	</xsl:template>
	<!--This template will return the tour name -->
	<xsl:template name="getTourName">
		<xsl:param name="pTourId"/>
		<xsl:value-of select="key('TripTourId',$pTourId)/@Name"/>
	</xsl:template>
	<!--This template will return the tour duration -->
	<xsl:template name="getTourDuration">
		<xsl:param name="pTourId"/>
		<xsl:value-of select="key('TripTourId',$pTourId)/TourFacts/@NoOfDays"/>
	</xsl:template>
</xsl:stylesheet> 