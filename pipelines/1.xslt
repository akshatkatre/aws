<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"/>
	<xsl:key name="TripTourId" match="/Company/TourList/Tour" use="@Id" />
	<xsl:template match="Company">
		<table width="100%" border="1">
			<th>Trip Id</th>
			<th>Tour</th>
			<th>Dates</th>
			<th>Duration</th>
			<th>Number of Customers</th>
			<th>Average Customer Rating</th>
			<th>Total Collections</th>
			<xsl:apply-templates select="TripList/Trip">
				<!--<xsl:sort select="PrimaryInformation/@FirstName"/>-->
			</xsl:apply-templates>
		</table>
	</xsl:template>
	<xsl:template match="TripList/Trip">
		<tr>
			<td>
				<xsl:value-of select="@Id" />
			</td>
			<td>
				<xsl:call-template name="getTourName">
					<xsl:with-param name="pTourId" select = "@TourId" />
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="@StartDate" /> - <xsl:value-of select="@StartDate" />
			</td>
			<td>
			<xsl:call-template name="getTourDuration">
					<xsl:with-param name="pTourId" select = "@TourId" />
				</xsl:call-template>
			</td>
			<td>
				<xsl:value-of select="count(Participants/Customer)"/>
			</td>
			<td>
				<xsl:value-of select="sum(Participants/Customer/@SatisfactionScore) div count(Participants/Customer)"/>
			</td>
			<td>
				<xsl:value-of select="count(Participants/Customer) * key('TripTourId',@TourId)/TourFacts/@CostPerPerson"/>
			</td>
		</tr>              
	</xsl:template>
	<xsl:template name="getTourName">
		<xsl:param name="pTourId"/>
		<xsl:value-of select="key('TripTourId',$pTourId)/@Name"/>
	</xsl:template>
	<xsl:template name="getTourDuration">
		<xsl:param name="pTourId"/>
		<xsl:value-of select="key('TripTourId',$pTourId)/TourFacts/@NoOfDays"/>
	</xsl:template>
</xsl:stylesheet> 