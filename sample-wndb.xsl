<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="text" encoding="UTF-8"/>

    <!-- <xsl:template match="text()">        
        <xsl:apply-templates/>
    </xsl:template>-->

    <xsl:template match="/">
        <xsl:apply-templates select="/data/concepts/concept"/>
    </xsl:template>

    <xsl:template match="/data/concepts/concept">
        <xsl:variable name="conc_id">
            <xsl:value-of select="./@id"/>
        </xsl:variable>
        <xsl:value-of select="$conc_id"/>
        <xsl:text> 01 n 01</xsl:text>
        <xsl:for-each select="/data/synonyms/entry_rel[@concept_id=$conc_id]">
            <xsl:variable name="text_id">
                <xsl:value-of select="@entry_id"/>
            </xsl:variable>
            <xsl:if test="/data/entries/entry[@id=$text_id]/synt_type/text()='N'">
                <xsl:text> </xsl:text>
                <xsl:call-template name="translit">
                    <xsl:with-param name="str"
                        select="/data/entries/entry[@id=$text_id]/name/text()"/>
                </xsl:call-template>
                <xsl:text> 0</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="count(/data/relations/rel[@from=$conc_id]) &lt; 10 ">        
        <xsl:text> 00</xsl:text>
        </xsl:if>
        <xsl:if test="count(/data/relations/rel[@from=$conc_id]) &gt; 9 ">        
            <xsl:text> 0</xsl:text>
        </xsl:if>
        <xsl:value-of select="count(/data/relations/rel[@from=$conc_id])"/>
        <xsl:for-each select="/data/relations/rel[@from=$conc_id and @name='ВЫШЕ']">
            <xsl:variable name="to_id">
                <xsl:value-of select="./@to"/>
            </xsl:variable>
            <xsl:text> @ </xsl:text>
            <xsl:value-of select="@to"/>
            <xsl:text> {</xsl:text>         
            <xsl:call-template name="translit">
                <xsl:with-param name="str"
                    select="//concept[@id=$to_id]/name/text()"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
            <xsl:text> n 0000</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="/data/relations/rel[@from=$conc_id and @name='НИЖЕ']">
            <xsl:variable name="to_id">
                <xsl:value-of select="./@to"/>
            </xsl:variable>
            <xsl:text> ~ </xsl:text>
            <xsl:value-of select="@to"/>
            <xsl:text> {</xsl:text>
            <xsl:call-template name="translit">
                <xsl:with-param name="str"
                    select="//concept[@id=$to_id]/name/text()"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
            <xsl:text> n 0000</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="/data/relations/rel[@from=$conc_id and @name='ЧАСТЬ']">
            <xsl:variable name="to_id">
                <xsl:value-of select="./@to"/>
            </xsl:variable>
            <xsl:text> %p </xsl:text>
            <xsl:value-of select="@to"/>
            <xsl:text> {</xsl:text>
            <xsl:call-template name="translit">
                <xsl:with-param name="str"
                    select="//concept[@id=$to_id]/name/text()"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
            <xsl:text> n 0000</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="/data/relations/rel[@from=$conc_id and @name='ЦЕЛОЕ']">
            <xsl:variable name="to_id">
                <xsl:value-of select="./@to"/>
            </xsl:variable>
            <xsl:text> #p </xsl:text>
            <xsl:value-of select="@to"/>
            <xsl:text> {</xsl:text>
            <xsl:call-template name="translit">
                <xsl:with-param name="str"
                    select="//concept[@id=$to_id]/name/text()"/>
            </xsl:call-template>
            <xsl:text>}</xsl:text>
            <xsl:text> n 0000</xsl:text>
        </xsl:for-each>
        <xsl:if test="gloss">
            <xsl:text> | </xsl:text>
            <xsl:value-of select="./gloss/text()"/>
            <xsl:text>
</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- <xsl:template name="txt" match="/data/entries/entry">
        <xsl:param name="t"/>
        <xsl:param name="c"/>  
        
    </xsl:template>-->

    <!-- <xsl:template match="/data/entries/entry[./synt_type/text()='V']">
        <xsl:variable name="text_id"><xsl:value-of select="./@id"/></xsl:variable>
        <xsl:variable name="con_id"><xsl:value-of
            select="/data/synonyms/entry_rel[@entry_id=$text_id]/@concept_id"/></xsl:variable>
        http://labinform.ru/pub/ruthes/wn/wn30/instances/word-<xsl:call-template name="translit"
            ><xsl:with-param name="str" select="./name/text()"/></xsl:call-template> inSynset http://labinform.ru/pub/ruthes/wn/wn30/instances/synset-verb-<xsl:call-template
                name="translit"><xsl:with-param name="str"
                    select="/data/concepts/concept[@id=$con_id]/name/text()"
                /></xsl:call-template>-<xsl:value-of select="$con_id"/>
    </xsl:template> 
    
    <xsl:template match="/data/entries/entry[./synt_type/text()='Adj']">
        <xsl:variable name="text_id"><xsl:value-of select="./@id"/></xsl:variable>
        <xsl:variable name="con_id"><xsl:value-of
            select="/data/synonyms/entry_rel[@entry_id=$text_id]/@concept_id"/></xsl:variable>
        http://labinform.ru/pub/ruthes/wn/wn30/instances/word-<xsl:call-template name="translit"
            ><xsl:with-param name="str" select="./name/text()"/></xsl:call-template> inSynset http://labinform.ru/pub/ruthes/wn/wn30/instances/synset-adjective-<xsl:call-template
                name="translit"><xsl:with-param name="str"
                    select="/data/concepts/concept[@id=$con_id]/name/text()"
                /></xsl:call-template>-<xsl:value-of select="$con_id"/>
    </xsl:template> 

    <xsl:template match="/data/entries/entry[./synt_type/text()='Adv']">
        <xsl:variable name="text_id"><xsl:value-of select="./@id"/></xsl:variable>
        <xsl:variable name="con_id"><xsl:value-of
            select="/data/synonyms/entry_rel[@entry_id=$text_id]/@concept_id"/></xsl:variable>
        http://labinform.ru/pub/ruthes/wn/wn30/instances/word-<xsl:call-template name="translit"
            ><xsl:with-param name="str" select="./name/text()"/></xsl:call-template> inSynset http://labinform.ru/pub/ruthes/wn/wn30/instances/synset-adverb-<xsl:call-template
                name="translit"><xsl:with-param name="str"
                    select="/data/concepts/concept[@id=$con_id]/name/text()"
                /></xsl:call-template>-<xsl:value-of select="$con_id"/>
    </xsl:template> -->


    <!--  
      <xsl:template match="/data/entries/entry[./synt_type/text()='N']">
        <xsl:variable name="text_id"><xsl:value-of  select="./@id"/></xsl:variable>        
        http://labinform.ru/pub/ruthes/wn/wn30/instances/word-noun-<xsl:value-of select="./name"/>-<xsl:value-of select="/data/synonyms/entry_rel[@entry_id=$text_id]/@concept_id"/>        
    </xsl:template>
    
      <xsl:template match="/data/entries/entry[./synt_type/text()='V']">
        <xsl:variable name="text_id"><xsl:value-of  select="./@id"/></xsl:variable>        
        http://labinform.ru/pub/ruthes/wn/wn30/instances/word-verb-<xsl:value-of select="./name"/>-<xsl:value-of select="/data/synonyms/entry_rel[@entry_id=$text_id]/@concept_id"/>        
    </xsl:template>
    
    <xsl:template match="/data/entries/entry[./synt_type/text()='Adj']">
        <xsl:variable name="text_id"><xsl:value-of  select="./@id"/></xsl:variable>        
        http://labinform.ru/pub/ruthes/wn/wn30/instances/word-adjective-<xsl:value-of select="./name"/>-<xsl:value-of select="/data/synonyms/entry_rel[@entry_id=$text_id]/@concept_id"/>        
    </xsl:template>
    
    <xsl:template match="/data/entries/entry[./synt_type/text()='Adv']">
        <xsl:variable name="text_id"><xsl:value-of  select="./@id"/></xsl:variable>        
        http://labinform.ru/pub/ruthes/wn/wn30/instances/word-adverb-<xsl:value-of select="./name"/>-<xsl:value-of select="/data/synonyms/entry_rel[@entry_id=$text_id]/@concept_id"/>        
    </xsl:template>-->


    <!-- KAD: Транслитерация -->
    <xsl:variable name="l-rus" select="'абвгдеёзийклмнопрстуфхьыъэАБВГДЕЁЗИЙКЛМНОПРСТУФХЬЫЪЭ'"/>
    <xsl:variable name="l-trans" select="'abvgdeеzijklmnoprstufh`y`eABVGDEEZIJKLMNOPRSTUFH`Y`E'"/>
    <xsl:template name="translit" match="text()">
        <xsl:param name="str"/>
        <xsl:variable name="q1" select="$str"/>
        <xsl:variable name="q2" select="normalize-space(translate($q1,$l-rus,$l-trans))"/>
        <xsl:variable name="q3">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q2"/>
                <xsl:with-param name="search-for" select="'ж'"/>
                <xsl:with-param name="replace-to" select="'zh'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="q4">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q3"/>
                <xsl:with-param name="search-for" select="'ш'"/>
                <xsl:with-param name="replace-to" select="'sh'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="q4c">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q4"/>
                <xsl:with-param name="search-for" select="'щ'"/>
                <xsl:with-param name="replace-to" select="'shch'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="q5">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q4c"/>
                <xsl:with-param name="search-for" select="'ю'"/>
                <xsl:with-param name="replace-to" select="'yu'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="q6">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q5"/>
                <xsl:with-param name="search-for" select="'я'"/>
                <xsl:with-param name="replace-to" select="'ya'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="q7">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q6"/>
                <xsl:with-param name="search-for" select="'ц'"/>
                <xsl:with-param name="replace-to" select="'ts'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="q8">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q7"/>
                <xsl:with-param name="search-for" select="'ч'"/>
                <xsl:with-param name="replace-to" select="'ch'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="q3u">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q8"/>
                <xsl:with-param name="search-for" select="'Ж'"/>
                <xsl:with-param name="replace-to" select="'ZH'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="q4u">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q3u"/>
                <xsl:with-param name="search-for" select="'Ш'"/>
                <xsl:with-param name="replace-to" select="'SH'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="q4uc">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q4u"/>
                <xsl:with-param name="search-for" select="'Щ'"/>
                <xsl:with-param name="replace-to" select="'SHCH'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="q5u">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q4uc"/>
                <xsl:with-param name="search-for" select="'Ю'"/>
                <xsl:with-param name="replace-to" select="'YU'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="q6u">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q5u"/>
                <xsl:with-param name="search-for" select="'Я'"/>
                <xsl:with-param name="replace-to" select="'YA'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="q7u">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q6u"/>
                <xsl:with-param name="search-for" select="'Ц'"/>
                <xsl:with-param name="replace-to" select="'TS'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="q8u">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q7u"/>
                <xsl:with-param name="search-for" select="'Ч'"/>
                <xsl:with-param name="replace-to" select="'CH'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="qSpace">
            <xsl:call-template name="replace">
                <xsl:with-param name="str" select="$q8u"/>
                <xsl:with-param name="search-for" select="' '"/>
                <xsl:with-param name="replace-to" select="'_'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$qSpace"/>
    </xsl:template>

    <xsl:template name="replace">
        <xsl:param name="str"/>
        <xsl:param name="search-for"/>
        <xsl:param name="replace-to"/>
        <xsl:choose>
            <xsl:when test="contains($str, $search-for)">
                <xsl:value-of select="substring-before($str, $search-for)"/>
                <xsl:copy-of select="$replace-to"/>
                <xsl:call-template name="replace">
                    <xsl:with-param name="str" select="substring-after($str, $search-for)"/>
                    <xsl:with-param name="search-for" select="$search-for"/>
                    <xsl:with-param name="replace-to" select="$replace-to"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <!-- /KAD: Транслитерация -->

</xsl:stylesheet>
