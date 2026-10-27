<?xml version='1.0' encoding='utf-8'?>
<COPASI xmlns="http://www.copasi.org/static/schema" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:ns2="http://purl.org/dc/terms/" xmlns:ns3="http://www.copasi.org/RDF/MiriamTerms#" xmlns:ns4="http://www.w3.org/2001/vcard-rdf/3.0#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" versionMajor="4" versionMinor="48" versionDevel="311" copasiSourcesModified="0">
  <ListOfFunctions>
    <Function key="Function_81" name="Function for MAPKKK activation" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_81">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        V1*MKKK/((1+(MAPK_PP/Ki)^n)*(K1+MKKK))
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_671" name="K1" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_670" name="Ki" order="1" role="constant" />
        <ParameterDescription key="FunctionParameter_669" name="MAPK_PP" order="2" role="modifier" />
        <ParameterDescription key="FunctionParameter_668" name="MKKK" order="3" role="substrate" />
        <ParameterDescription key="FunctionParameter_678" name="V1" order="4" role="constant" />
        <ParameterDescription key="FunctionParameter_679" name="n" order="5" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_82" name="Function for MAPKKK inactivation" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_82">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        V2*MKKK_P/(KK2+MKKK_P)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_675" name="KK2" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_674" name="MKKK_P" order="1" role="substrate" />
        <ParameterDescription key="FunctionParameter_672" name="V2" order="2" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_83" name="Function for phosphorylation of MAPKK" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_83">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        k3*MKKK_P*MKK/(KK3+MKK)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_690" name="KK3" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_691" name="MKK" order="1" role="substrate" />
        <ParameterDescription key="FunctionParameter_692" name="MKKK_P" order="2" role="modifier" />
        <ParameterDescription key="FunctionParameter_693" name="k3" order="3" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_84" name="Function for phosphorylation of MAPKK-P" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_84">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        k4*MKKK_P*MKK_P/(KK4+MKK_P)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_698" name="KK4" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_699" name="MKKK_P" order="1" role="modifier" />
        <ParameterDescription key="FunctionParameter_700" name="MKK_P" order="2" role="substrate" />
        <ParameterDescription key="FunctionParameter_701" name="k4" order="3" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_85" name="Function for dephosphorylation of MAPKK-PP" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_85">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        V5*MKK_PP/(KK5+MKK_PP)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_689" name="KK5" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_706" name="MKK_PP" order="1" role="substrate" />
        <ParameterDescription key="FunctionParameter_707" name="V5" order="2" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_86" name="Function for dephosphorylation of MAPKK-P" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_86">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        V6*MKK_P/(KK6+MKK_P)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_711" name="KK6" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_712" name="MKK_P" order="1" role="substrate" />
        <ParameterDescription key="FunctionParameter_713" name="V6" order="2" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_87" name="Function for phosphorylation of MAPK" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_87">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        k7*MKK_PP*MAPK/(KK7+MAPK)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_718" name="KK7" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_719" name="MAPK" order="1" role="substrate" />
        <ParameterDescription key="FunctionParameter_720" name="MKK_PP" order="2" role="modifier" />
        <ParameterDescription key="FunctionParameter_721" name="k7" order="3" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_88" name="Function for phosphorylation of MAPK-P" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_88">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        k8*MKK_PP*MAPK_P/(KK8+MAPK_P)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_726" name="KK8" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_727" name="MAPK_P" order="1" role="substrate" />
        <ParameterDescription key="FunctionParameter_728" name="MKK_PP" order="2" role="modifier" />
        <ParameterDescription key="FunctionParameter_729" name="k8" order="3" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_89" name="Function for dephosphorylation of MAPK-PP" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_89">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        V9*MAPK_PP/(KK9+MAPK_PP)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_717" name="KK9" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_734" name="MAPK_PP" order="1" role="substrate" />
        <ParameterDescription key="FunctionParameter_735" name="V9" order="2" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
    <Function key="Function_90" name="Function for dephosphorylation of MAPK-P" type="UserDefined" reversible="false">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Function_90">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        V10*MAPK_P/(KK10+MAPK_P)
      </Expression>
      <ListOfParameterDescriptions>
        <ParameterDescription key="FunctionParameter_739" name="KK10" order="0" role="constant" />
        <ParameterDescription key="FunctionParameter_740" name="MAPK_P" order="1" role="substrate" />
        <ParameterDescription key="FunctionParameter_741" name="V10" order="2" role="constant" />
      </ListOfParameterDescriptions>
    </Function>
  </ListOfFunctions>
  <Model key="Model_1" name="Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade" simulationType="time" timeUnit="s" volumeUnit="l" areaUnit="m²" lengthUnit="m" quantityUnit="nmol" type="deterministic" avogadroConstant="6.0221407599999999e+23">
    <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Model_1">
    <ns2:bibliographicCitation>
      <rdf:Bag>
        <rdf:li>
          <rdf:Description>
            <ns3:isDescribedBy rdf:resource="http://identifiers.org/pubmed/10712587" />
          </rdf:Description>
        </rdf:li>
      </rdf:Bag>
    </ns2:bibliographicCitation>
    <ns2:created>
      <rdf:Description>
        <ns2:W3CDTF>2005-02-12T00:18:12Z</ns2:W3CDTF>
      </rdf:Description>
    </ns2:created>
    <ns2:creator>
      <rdf:Bag>
        <rdf:li>
          <rdf:Description>
            <ns4:EMAIL>Herbert_Sauro@kgi.edu</ns4:EMAIL>
            <ns4:N>
              <rdf:Description>
                <ns4:Family>Sauro</ns4:Family>
                <ns4:Given>Herbert</ns4:Given>
              </rdf:Description>
            </ns4:N>
            <ns4:ORG>
              <rdf:Description>
                <ns4:Orgname>Keck Graduate Institute</ns4:Orgname>
              </rdf:Description>
            </ns4:ORG>
          </rdf:Description>
        </rdf:li>
      </rdf:Bag>
    </ns2:creator>
    <ns2:modified>
      <rdf:Description>
        <ns2:W3CDTF>2014-05-30T11:51:29Z</ns2:W3CDTF>
      </rdf:Description>
    </ns2:modified>
    <ns3:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/biomodels.db/BIOMD0000000010" />
      </rdf:Bag>
    </ns3:is>
    <ns3:is>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/biomodels.db/MODEL6615119181" />
      </rdf:Bag>
    </ns3:is>
    <ns3:isHomologTo>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/reactome/REACT_634" />
      </rdf:Bag>
    </ns3:isHomologTo>
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0000165" />
      </rdf:Bag>
    </ns3:isVersionOf>
    <ns3:occursIn>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/taxonomy/8355" />
      </rdf:Bag>
    </ns3:occursIn>
  </rdf:Description>
</rdf:RDF>
    </MiriamAnnotation>
    <Comment>
      
  <html:body>
    <html:div class="dc:title">Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade</html:div>
    <html:div class="dc:description">
      <html:p>The combination of ultrasensitivity and negative feedback bring sustained oscillations in the mitogen-activated protein kinase cascades.</html:p>
    </html:div>
    <html:div class="dc:bibliographicCitation">
      <html:p>This model is described in the article:</html:p>
      <html:div class="bibo:title">
        <html:a href="http://identifiers.org/pubmed/10712587" title="Access to this publication">Negative feedback and ultrasensitivity can bring about oscillations in the mitogen-activated protein kinase cascades.</html:a>
      </html:div>
      <html:div class="bibo:authorList">Kholodenko BN</html:div>
      <html:div class="bibo:Journal">Eur. J. Biochem. 2000; 267(6):1583-8</html:div>
      <html:p>Abstract:</html:p>
      <html:div class="bibo:abstract">
        <html:p>Functional organization of signal transduction into protein phosphorylation cascades, such as the mitogen-activated protein kinase (MAPK) cascades, greatly enhances the sensitivity of cellular targets to external stimuli. The sensitivity increases multiplicatively with the number of cascade levels, so that a tiny change in a stimulus results in a large change in the response, the phenomenon referred to as ultrasensitivity. In a variety of cell types, the MAPK cascades are imbedded in long feedback loops, positive or negative, depending on whether the terminal kinase stimulates or inhibits the activation of the initial level. Here we demonstrate that a negative feedback loop combined with intrinsic ultrasensitivity of the MAPK cascade can bring about sustained oscillations in MAPK phosphorylation. Based on recent kinetic data on the MAPK cascades, we predict that the period of oscillations can range from minutes to hours. The phosphorylation level can vary between the base level and almost 100% of the total protein. The oscillations of the phosphorylation cascades and slow protein diffusion in the cytoplasm can lead to intracellular waves of phospho-proteins.</html:p>
      </html:div>
    </html:div>
    <html:div class="dc:publisher">
      <html:p>This model is hosted on        <html:a href="http://www.ebi.ac.uk/biomodels/">BioModels Database</html:a>
            and identified by:        <html:a href="http://identifiers.org/biomodels.db/BIOMD0000000010">BIOMD0000000010</html:a>
            .        </html:p>
      <html:p>To cite BioModels Database, please use:        <html:a href="http://identifiers.org/pubmed/20587024" title="Latest BioModels Database publication">BioModels Database: An enhanced, curated and annotated resource for published quantitative kinetic models</html:a>
            .        </html:p>
    </html:div>
    <html:div class="dc:license">
      <html:p>To the extent possible under law, all copyright and related or neighbouring rights to this encoded model have been dedicated to the public domain worldwide. Please refer to        <html:a href="http://creativecommons.org/publicdomain/zero/1.0/" title="Access to: CC0 1.0 Universal (CC0 1.0), Public Domain Dedication">CC0 Public Domain Dedication</html:a>
            for more information.        </html:p>
    </html:div>
  </html:body>

    </Comment>
    <ListOfCompartments>
      <Compartment key="Compartment_0" name="uVol" simulationType="fixed" dimensionality="3" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Compartment_0">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Compartment>
    </ListOfCompartments>
    <ListOfMetabolites>
      <Metabolite key="Metabolite_0" name="Mos" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Metabolite_0">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/uniprot/P09560" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_1" name="Mos-P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Metabolite_1">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/uniprot/P09560" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_2" name="Mek1" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Metabolite_2">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/uniprot/Q05116" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_3" name="Mek1-P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Metabolite_3">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/uniprot/Q05116" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_4" name="Mek1-PP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Metabolite_4">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/uniprot/Q05116" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_5" name="Erk2" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Metabolite_5">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/uniprot/P26696" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_6" name="Erk2-P" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Metabolite_6">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/uniprot/P26696" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
      <Metabolite key="Metabolite_7" name="Erk2-PP" simulationType="reactions" compartment="Compartment_0" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Metabolite_7">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/uniprot/P26696" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
      </Metabolite>
    </ListOfMetabolites>
    <ListOfReactions>
      <Reaction key="Reaction_0" name="MAPKKK activation" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_0">
    <ns3:isHomologTo>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/reactome/REACT_525" />
      </rdf:Bag>
    </ns3:isHomologTo>
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0008349" />
        <rdf:li rdf:resource="http://identifiers.org/ec-code/2.7.11.1" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0000185" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_0" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_1" stoichiometry="1" />
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_7" stoichiometry="1" />
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_0" name="V1" value="2.5" />
          <Constant key="Parameter_1" name="Ki" value="9" />
          <Constant key="Parameter_2" name="n" value="1" />
          <Constant key="Parameter_3" name="K1" value="10" />
        </ListOfConstants>
        <KineticLaw function="Function_81" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_671">
              <SourceParameter reference="Parameter_3" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_670">
              <SourceParameter reference="Parameter_1" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_669">
              <SourceParameter reference="Metabolite_7" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_668">
              <SourceParameter reference="Metabolite_0" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_678">
              <SourceParameter reference="Parameter_0" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_679">
              <SourceParameter reference="Parameter_2" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_1" name="MAPKKK inactivation" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_1">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/ec-code/3.1.3.16" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0051390" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006470" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_1" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_0" stoichiometry="1" />
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_4" name="V2" value="0.25" />
          <Constant key="Parameter_5" name="KK2" value="8" />
        </ListOfConstants>
        <KineticLaw function="Function_82" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_675">
              <SourceParameter reference="Parameter_5" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_674">
              <SourceParameter reference="Metabolite_1" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_672">
              <SourceParameter reference="Parameter_4" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_2" name="phosphorylation of MAPKK" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_2">
    <ns3:isHomologTo>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/reactome/REACT_614" />
      </rdf:Bag>
    </ns3:isHomologTo>
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0004709" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006468" />
        <rdf:li rdf:resource="http://identifiers.org/ec-code/2.7.11.25" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_2" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_3" stoichiometry="1" />
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_1" stoichiometry="1" />
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_6" name="k3" value="0.025" />
          <Constant key="Parameter_7" name="KK3" value="15" />
        </ListOfConstants>
        <KineticLaw function="Function_83" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_690">
              <SourceParameter reference="Parameter_7" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_691">
              <SourceParameter reference="Metabolite_2" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_692">
              <SourceParameter reference="Metabolite_1" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_693">
              <SourceParameter reference="Parameter_6" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_3" name="phosphorylation of MAPKK-P" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_3">
    <ns3:isHomologTo>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/reactome/REACT_614" />
      </rdf:Bag>
    </ns3:isHomologTo>
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006468" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0000186" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0004709" />
        <rdf:li rdf:resource="http://identifiers.org/ec-code/2.7.11.25" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_3" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_4" stoichiometry="1" />
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_1" stoichiometry="1" />
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_8" name="k4" value="0.025" />
          <Constant key="Parameter_9" name="KK4" value="15" />
        </ListOfConstants>
        <KineticLaw function="Function_84" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_698">
              <SourceParameter reference="Parameter_9" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_699">
              <SourceParameter reference="Metabolite_1" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_700">
              <SourceParameter reference="Metabolite_3" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_701">
              <SourceParameter reference="Parameter_8" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_4" name="dephosphorylation of MAPKK-PP" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_4">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/ec-code/3.1.3.16" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006470" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0051389" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_4" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_3" stoichiometry="1" />
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_10" name="V5" value="0.75" />
          <Constant key="Parameter_11" name="KK5" value="15" />
        </ListOfConstants>
        <KineticLaw function="Function_85" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_689">
              <SourceParameter reference="Parameter_11" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_706">
              <SourceParameter reference="Metabolite_4" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_707">
              <SourceParameter reference="Parameter_10" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_5" name="dephosphorylation of MAPKK-P" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_5">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006470" />
        <rdf:li rdf:resource="http://identifiers.org/ec-code/3.1.3.16" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_3" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_2" stoichiometry="1" />
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_12" name="V6" value="0.75" />
          <Constant key="Parameter_13" name="KK6" value="15" />
        </ListOfConstants>
        <KineticLaw function="Function_86" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_711">
              <SourceParameter reference="Parameter_13" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_712">
              <SourceParameter reference="Metabolite_3" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_713">
              <SourceParameter reference="Parameter_12" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_6" name="phosphorylation of MAPK" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_6">
    <ns3:hasVersion>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/reactome/REACT_2247" />
        <rdf:li rdf:resource="http://identifiers.org/reactome/REACT_136" />
      </rdf:Bag>
    </ns3:hasVersion>
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/ec-code/2.7.12.2" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006468" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0004708" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_5" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_6" stoichiometry="1" />
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_4" stoichiometry="1" />
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_14" name="k7" value="0.025" />
          <Constant key="Parameter_15" name="KK7" value="15" />
        </ListOfConstants>
        <KineticLaw function="Function_87" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_718">
              <SourceParameter reference="Parameter_15" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_719">
              <SourceParameter reference="Metabolite_5" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_720">
              <SourceParameter reference="Metabolite_4" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_721">
              <SourceParameter reference="Parameter_14" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_7" name="phosphorylation of MAPK-P" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_7">
    <ns3:hasVersion>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/reactome/REACT_136" />
        <rdf:li rdf:resource="http://identifiers.org/reactome/REACT_2247" />
      </rdf:Bag>
    </ns3:hasVersion>
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0000187" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0004708" />
        <rdf:li rdf:resource="http://identifiers.org/ec-code/2.7.12.2" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006468" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_6" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_7" stoichiometry="1" />
        </ListOfProducts>
        <ListOfModifiers>
          <Modifier metabolite="Metabolite_4" stoichiometry="1" />
        </ListOfModifiers>
        <ListOfConstants>
          <Constant key="Parameter_16" name="k8" value="0.025" />
          <Constant key="Parameter_17" name="KK8" value="15" />
        </ListOfConstants>
        <KineticLaw function="Function_88" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_726">
              <SourceParameter reference="Parameter_17" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_727">
              <SourceParameter reference="Metabolite_6" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_728">
              <SourceParameter reference="Metabolite_4" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_729">
              <SourceParameter reference="Parameter_16" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_8" name="dephosphorylation of MAPK-PP" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_8">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006470" />
        <rdf:li rdf:resource="http://identifiers.org/ec-code/3.1.3.16" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0000188" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_7" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_6" stoichiometry="1" />
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_18" name="V9" value="0.5" />
          <Constant key="Parameter_19" name="KK9" value="15" />
        </ListOfConstants>
        <KineticLaw function="Function_89" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_717">
              <SourceParameter reference="Parameter_19" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_734">
              <SourceParameter reference="Metabolite_7" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_735">
              <SourceParameter reference="Parameter_18" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
      <Reaction key="Reaction_9" name="dephosphorylation of MAPK-P" reversible="false" fast="false" addNoise="false">
        <MiriamAnnotation>
<rdf:RDF>
  <rdf:Description rdf:about="#Reaction_9">
    <ns3:isVersionOf>
      <rdf:Bag>
        <rdf:li rdf:resource="http://identifiers.org/ec-code/3.1.3.16" />
        <rdf:li rdf:resource="http://identifiers.org/go/GO:0006470" />
      </rdf:Bag>
    </ns3:isVersionOf>
  </rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ListOfSubstrates>
          <Substrate metabolite="Metabolite_6" stoichiometry="1" />
        </ListOfSubstrates>
        <ListOfProducts>
          <Product metabolite="Metabolite_5" stoichiometry="1" />
        </ListOfProducts>
        <ListOfConstants>
          <Constant key="Parameter_20" name="V10" value="0.5" />
          <Constant key="Parameter_21" name="KK10" value="15" />
        </ListOfConstants>
        <KineticLaw function="Function_90" unitType="Default" scalingCompartment="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]">
          <ListOfCallParameters>
            <CallParameter functionParameter="FunctionParameter_739">
              <SourceParameter reference="Parameter_21" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_740">
              <SourceParameter reference="Metabolite_6" />
            </CallParameter>
            <CallParameter functionParameter="FunctionParameter_741">
              <SourceParameter reference="Parameter_20" />
            </CallParameter>
          </ListOfCallParameters>
        </KineticLaw>
      </Reaction>
    </ListOfReactions>
    <ListOfModelParameterSets activeSet="ModelParameterSet_1">
      <ModelParameterSet key="ModelParameterSet_1" name="Initial State">
        <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#ModelParameterSet_1">
</rdf:Description>
</rdf:RDF>
        </MiriamAnnotation>
        <ModelParameterGroup cn="String=Initial Time" type="Group">
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade" value="0" type="Model" simulationType="time" />
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Compartment Sizes" type="Group">
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol]" value="1" type="Compartment" simulationType="fixed" />
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Species Values" type="Group">
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mos]" value="54199266840000000" type="Species" simulationType="reactions" />
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mos-P]" value="6022140760000000" type="Species" simulationType="reactions" />
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mek1]" value="1.6861994128e+17" type="Species" simulationType="reactions" />
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mek1-P]" value="6022140760000000" type="Species" simulationType="reactions" />
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mek1-PP]" value="6022140760000000" type="Species" simulationType="reactions" />
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Erk2]" value="1.6861994128e+17" type="Species" simulationType="reactions" />
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Erk2-P]" value="6022140760000000" type="Species" simulationType="reactions" />
          <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Erk2-PP]" value="6022140760000000" type="Species" simulationType="reactions" />
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Initial Global Quantities" type="Group">
        </ModelParameterGroup>
        <ModelParameterGroup cn="String=Kinetic Parameters" type="Group">
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[MAPKKK activation]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[MAPKKK activation],ParameterGroup=Parameters,Parameter=V1" value="2.5" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[MAPKKK activation],ParameterGroup=Parameters,Parameter=Ki" value="9" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[MAPKKK activation],ParameterGroup=Parameters,Parameter=n" value="1" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[MAPKKK activation],ParameterGroup=Parameters,Parameter=K1" value="10" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[MAPKKK inactivation]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[MAPKKK inactivation],ParameterGroup=Parameters,Parameter=V2" value="0.25" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[MAPKKK inactivation],ParameterGroup=Parameters,Parameter=KK2" value="8" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPKK]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPKK],ParameterGroup=Parameters,Parameter=k3" value="0.025000000000000001" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPKK],ParameterGroup=Parameters,Parameter=KK3" value="15" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPKK-P]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPKK-P],ParameterGroup=Parameters,Parameter=k4" value="0.025000000000000001" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPKK-P],ParameterGroup=Parameters,Parameter=KK4" value="15" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPKK-PP]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPKK-PP],ParameterGroup=Parameters,Parameter=V5" value="0.75" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPKK-PP],ParameterGroup=Parameters,Parameter=KK5" value="15" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPKK-P]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPKK-P],ParameterGroup=Parameters,Parameter=V6" value="0.75" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPKK-P],ParameterGroup=Parameters,Parameter=KK6" value="15" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPK]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPK],ParameterGroup=Parameters,Parameter=k7" value="0.025000000000000001" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPK],ParameterGroup=Parameters,Parameter=KK7" value="15" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPK-P]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPK-P],ParameterGroup=Parameters,Parameter=k8" value="0.025000000000000001" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[phosphorylation of MAPK-P],ParameterGroup=Parameters,Parameter=KK8" value="15" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPK-PP]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPK-PP],ParameterGroup=Parameters,Parameter=V9" value="0.5" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPK-PP],ParameterGroup=Parameters,Parameter=KK9" value="15" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
          <ModelParameterGroup cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPK-P]" type="Reaction">
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPK-P],ParameterGroup=Parameters,Parameter=V10" value="0.5" type="ReactionParameter" simulationType="fixed" />
            <ModelParameter cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Reactions[dephosphorylation of MAPK-P],ParameterGroup=Parameters,Parameter=KK10" value="15" type="ReactionParameter" simulationType="fixed" />
          </ModelParameterGroup>
        </ModelParameterGroup>
      </ModelParameterSet>
    </ListOfModelParameterSets>
    <StateTemplate>
      <StateTemplateVariable objectReference="Model_1" />
      <StateTemplateVariable objectReference="Metabolite_3" />
      <StateTemplateVariable objectReference="Metabolite_6" />
      <StateTemplateVariable objectReference="Metabolite_0" />
      <StateTemplateVariable objectReference="Metabolite_2" />
      <StateTemplateVariable objectReference="Metabolite_5" />
      <StateTemplateVariable objectReference="Metabolite_1" />
      <StateTemplateVariable objectReference="Metabolite_4" />
      <StateTemplateVariable objectReference="Metabolite_7" />
      <StateTemplateVariable objectReference="Compartment_0" />
    </StateTemplate>
    <InitialState type="initialState">
      0 6022140760000000 6022140760000000 54199266840000000 1.6861994128e+17 1.6861994128e+17 6022140760000000 6022140760000000 6022140760000000 1 
    </InitialState>
  </Model>
  <ListOfTasks>
    <Task key="Task_17" name="Steady-State" type="steadyState" scheduled="false" updateModel="false">
      <Report reference="Report_11" target="" append="1" confirmOverwrite="1" />
      <Problem>
        <Parameter name="JacobianRequested" type="bool" value="1" />
        <Parameter name="StabilityAnalysisRequested" type="bool" value="1" />
      </Problem>
      <Method name="Enhanced Newton" type="EnhancedNewton">
        <Parameter name="Resolution" type="unsignedFloat" value="1.0000000000000001e-09" />
        <Parameter name="Derivation Factor" type="unsignedFloat" value="0.001" />
        <Parameter name="Use Newton" type="bool" value="1" />
        <Parameter name="Use Integration" type="bool" value="1" />
        <Parameter name="Use Back Integration" type="bool" value="0" />
        <Parameter name="Accept Negative Concentrations" type="bool" value="0" />
        <Parameter name="Iteration Limit" type="unsignedInteger" value="50" />
        <Parameter name="Maximum duration for forward integration" type="unsignedFloat" value="1000000000" />
        <Parameter name="Maximum duration for backward integration" type="unsignedFloat" value="1000000" />
        <Parameter name="Target Criterion" type="string" value="Distance and Rate" />
      </Method>
    </Task>
    <Task key="Task_18" name="Time-Course" type="timeCourse" scheduled="true" updateModel="false">
      <Report reference="Report_cross_engine" target="copasi-trajectory.tsv" append="0" confirmOverwrite="0" />
      <Problem>
        <Parameter name="AutomaticStepSize" type="bool" value="0" />
        <Parameter name="StepNumber" type="unsignedInteger" value="80" />
        <Parameter name="StepSize" type="float" value="50.0" />
        <Parameter name="Duration" type="float" value="4000.0" />
        <Parameter name="TimeSeriesRequested" type="bool" value="1" />
        <Parameter name="OutputStartTime" type="float" value="0" />
        <Parameter name="Output Event" type="bool" value="0" />
        <Parameter name="Start in Steady State" type="bool" value="0" />
        <Parameter name="Use Values" type="bool" value="0" />
        <Parameter name="Values" type="string" value="" />
      </Problem>
      <Method name="Deterministic (LSODA)" type="Deterministic(LSODA)">
        <Parameter name="Integrate Reduced Model" type="bool" value="0" />
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="1e-10" />
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="1e-12" />
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="100000" />
        <Parameter name="Max Internal Step Size" type="unsignedFloat" value="0" />
      </Method>
    </Task>
    <Task key="Task_19" name="Scan" type="scan" scheduled="false" updateModel="false">
      <Problem>
        <Parameter name="Subtask" type="unsignedInteger" value="1" />
        <ParameterGroup name="ScanItems">
        </ParameterGroup>
        <Parameter name="Subtask Output" type="string" value="subTaskDuring" />
        <Parameter name="Adjust initial conditions" type="bool" value="0" />
        <Parameter name="Continue on Error" type="bool" value="0" />
      </Problem>
      <Method name="Scan Framework" type="ScanFramework">
      </Method>
    </Task>
    <Task key="Task_20" name="Elementary Flux Modes" type="fluxMode" scheduled="false" updateModel="false">
      <Report reference="Report_13" target="" append="1" confirmOverwrite="1" />
      <Problem>
      </Problem>
      <Method name="EFM Algorithm" type="EFMAlgorithm">
      </Method>
    </Task>
    <Task key="Task_21" name="Optimization" type="optimization" scheduled="false" updateModel="false">
      <Report reference="Report_14" target="" append="1" confirmOverwrite="1" />
      <Problem>
        <Parameter name="Subtask" type="cn" value="CN=Root,Vector=TaskList[Steady-State]" />
        <ParameterText name="ObjectiveExpression" type="expression">
          
        </ParameterText>
        <Parameter name="Maximize" type="bool" value="0" />
        <Parameter name="Randomize Start Values" type="bool" value="0" />
        <Parameter name="Calculate Statistics" type="bool" value="1" />
        <Parameter name="Create Parameter Sets" type="bool" value="0" />
        <ParameterGroup name="OptimizationItemList">
        </ParameterGroup>
        <ParameterGroup name="OptimizationConstraintList">
        </ParameterGroup>
        <Parameter name="DisplayPopulations" type="bool" value="0" />
      </Problem>
      <Method name="Random Search" type="RandomSearch">
        <Parameter name="Log Verbosity" type="unsignedInteger" value="0" />
        <Parameter name="Number of Iterations" type="unsignedInteger" value="100000" />
        <Parameter name="Random Number Generator" type="unsignedInteger" value="1" />
        <Parameter name="Seed" type="unsignedInteger" value="0" />
      </Method>
    </Task>
    <Task key="Task_22" name="Parameter Estimation" type="parameterFitting" scheduled="false" updateModel="false">
      <Report reference="Report_15" target="" append="1" confirmOverwrite="1" />
      <Problem>
        <Parameter name="Maximize" type="bool" value="0" />
        <Parameter name="Randomize Start Values" type="bool" value="0" />
        <Parameter name="Calculate Statistics" type="bool" value="1" />
        <Parameter name="Create Parameter Sets" type="bool" value="0" />
        <ParameterGroup name="OptimizationItemList">
        </ParameterGroup>
        <ParameterGroup name="OptimizationConstraintList">
        </ParameterGroup>
        <Parameter name="DisplayPopulations" type="bool" value="0" />
        <Parameter name="Steady-State" type="cn" value="CN=Root,Vector=TaskList[Steady-State]" />
        <Parameter name="Time-Course" type="cn" value="CN=Root,Vector=TaskList[Time-Course]" />
        <Parameter name="Use Time Sens" type="bool" value="0" />
        <Parameter name="Time-Sens" type="cn" value="" />
        <ParameterGroup name="Experiment Set">
        </ParameterGroup>
        <ParameterGroup name="Validation Set">
          <Parameter name="Weight" type="unsignedFloat" value="1" />
          <Parameter name="Threshold" type="unsignedInteger" value="5" />
        </ParameterGroup>
      </Problem>
      <Method name="Evolutionary Programming" type="EvolutionaryProgram">
        <Parameter name="Log Verbosity" type="unsignedInteger" value="0" />
        <Parameter name="Number of Generations" type="unsignedInteger" value="200" />
        <Parameter name="Population Size" type="unsignedInteger" value="20" />
        <Parameter name="Random Number Generator" type="unsignedInteger" value="1" />
        <Parameter name="Seed" type="unsignedInteger" value="0" />
        <Parameter name="Stop after # Stalled Generations" type="unsignedInteger" value="0" />
      </Method>
    </Task>
    <Task key="Task_23" name="Metabolic Control Analysis" type="metabolicControlAnalysis" scheduled="false" updateModel="false">
      <Report reference="Report_16" target="" append="1" confirmOverwrite="1" />
      <Problem>
        <Parameter name="Steady-State" type="key" value="Task_17" />
      </Problem>
      <Method name="MCA Method (Reder)" type="MCAMethod(Reder)">
        <Parameter name="Modulation Factor" type="unsignedFloat" value="1.0000000000000001e-09" />
        <Parameter name="Use Reder" type="bool" value="1" />
        <Parameter name="Use Smallbone" type="bool" value="1" />
      </Method>
    </Task>
    <Task key="Task_24" name="Lyapunov Exponents" type="lyapunovExponents" scheduled="false" updateModel="false">
      <Report reference="Report_17" target="" append="1" confirmOverwrite="1" />
      <Problem>
        <Parameter name="ExponentNumber" type="unsignedInteger" value="3" />
        <Parameter name="DivergenceRequested" type="bool" value="1" />
        <Parameter name="TransientTime" type="float" value="0" />
      </Problem>
      <Method name="Wolf Method" type="WolfMethod">
        <Parameter name="Orthonormalization Interval" type="unsignedFloat" value="1" />
        <Parameter name="Overall time" type="unsignedFloat" value="1000" />
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="9.9999999999999995e-07" />
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="9.9999999999999998e-13" />
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="10000" />
      </Method>
    </Task>
    <Task key="Task_25" name="Time Scale Separation Analysis" type="timeScaleSeparationAnalysis" scheduled="false" updateModel="false">
      <Report reference="Report_18" target="" append="1" confirmOverwrite="1" />
      <Problem>
        <Parameter name="StepNumber" type="unsignedInteger" value="100" />
        <Parameter name="StepSize" type="float" value="0.01" />
        <Parameter name="Duration" type="float" value="1" />
        <Parameter name="TimeSeriesRequested" type="bool" value="1" />
        <Parameter name="OutputStartTime" type="float" value="0" />
      </Problem>
      <Method name="ILDM (LSODA,Deuflhard)" type="TimeScaleSeparation(ILDM,Deuflhard)">
        <Parameter name="Deuflhard Tolerance" type="unsignedFloat" value="0.0001" />
      </Method>
    </Task>
    <Task key="Task_26" name="Sensitivities" type="sensitivities" scheduled="false" updateModel="false">
      <Report reference="Report_19" target="" append="1" confirmOverwrite="1" />
      <Problem>
        <Parameter name="SubtaskType" type="unsignedInteger" value="1" />
        <ParameterGroup name="TargetFunctions">
          <Parameter name="SingleObject" type="cn" value="" />
          <Parameter name="ObjectListType" type="unsignedInteger" value="7" />
        </ParameterGroup>
        <ParameterGroup name="ListOfVariables">
          <ParameterGroup name="Variables">
            <Parameter name="SingleObject" type="cn" value="" />
            <Parameter name="ObjectListType" type="unsignedInteger" value="41" />
          </ParameterGroup>
          <ParameterGroup name="Variables">
            <Parameter name="SingleObject" type="cn" value="" />
            <Parameter name="ObjectListType" type="unsignedInteger" value="0" />
          </ParameterGroup>
        </ParameterGroup>
      </Problem>
      <Method name="Sensitivities Method" type="SensitivitiesMethod">
        <Parameter name="Delta factor" type="unsignedFloat" value="0.001" />
        <Parameter name="Delta minimum" type="unsignedFloat" value="9.9999999999999998e-13" />
      </Method>
    </Task>
    <Task key="Task_27" name="Moieties" type="moieties" scheduled="false" updateModel="false">
      <Report reference="Report_20" target="" append="1" confirmOverwrite="1" />
      <Problem>
      </Problem>
      <Method name="Householder Reduction" type="Householder">
      </Method>
    </Task>
    <Task key="Task_28" name="Cross Section" type="crosssection" scheduled="false" updateModel="false">
      <Problem>
        <Parameter name="AutomaticStepSize" type="bool" value="0" />
        <Parameter name="StepNumber" type="unsignedInteger" value="100" />
        <Parameter name="StepSize" type="float" value="0.01" />
        <Parameter name="Duration" type="float" value="1" />
        <Parameter name="TimeSeriesRequested" type="bool" value="1" />
        <Parameter name="OutputStartTime" type="float" value="0" />
        <Parameter name="Output Event" type="bool" value="0" />
        <Parameter name="Start in Steady State" type="bool" value="0" />
        <Parameter name="Use Values" type="bool" value="0" />
        <Parameter name="Values" type="string" value="" />
        <Parameter name="LimitCrossings" type="bool" value="0" />
        <Parameter name="NumCrossingsLimit" type="unsignedInteger" value="0" />
        <Parameter name="LimitOutTime" type="bool" value="0" />
        <Parameter name="LimitOutCrossings" type="bool" value="0" />
        <Parameter name="PositiveDirection" type="bool" value="1" />
        <Parameter name="NumOutCrossingsLimit" type="unsignedInteger" value="0" />
        <Parameter name="LimitUntilConvergence" type="bool" value="0" />
        <Parameter name="ConvergenceTolerance" type="float" value="9.9999999999999995e-07" />
        <Parameter name="Threshold" type="float" value="0" />
        <Parameter name="DelayOutputUntilConvergence" type="bool" value="0" />
        <Parameter name="OutputConvergenceTolerance" type="float" value="9.9999999999999995e-07" />
        <ParameterText name="TriggerExpression" type="expression">
          
        </ParameterText>
        <Parameter name="SingleVariable" type="cn" value="" />
      </Problem>
      <Method name="Deterministic (LSODA)" type="Deterministic(LSODA)">
        <Parameter name="Integrate Reduced Model" type="bool" value="0" />
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="9.9999999999999995e-07" />
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="9.9999999999999998e-13" />
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="100000" />
        <Parameter name="Max Internal Step Size" type="unsignedFloat" value="0" />
      </Method>
    </Task>
    <Task key="Task_29" name="Linear Noise Approximation" type="linearNoiseApproximation" scheduled="false" updateModel="false">
      <Report reference="Report_21" target="" append="1" confirmOverwrite="1" />
      <Problem>
        <Parameter name="Steady-State" type="key" value="Task_17" />
      </Problem>
      <Method name="Linear Noise Approximation" type="LinearNoiseApproximation">
      </Method>
    </Task>
    <Task key="Task_30" name="Time-Course Sensitivities" type="timeSensitivities" scheduled="false" updateModel="false">
      <Problem>
        <Parameter name="AutomaticStepSize" type="bool" value="0" />
        <Parameter name="StepNumber" type="unsignedInteger" value="100" />
        <Parameter name="StepSize" type="float" value="0.01" />
        <Parameter name="Duration" type="float" value="1" />
        <Parameter name="TimeSeriesRequested" type="bool" value="1" />
        <Parameter name="OutputStartTime" type="float" value="0" />
        <Parameter name="Output Event" type="bool" value="0" />
        <Parameter name="Start in Steady State" type="bool" value="0" />
        <Parameter name="Use Values" type="bool" value="0" />
        <Parameter name="Values" type="string" value="" />
        <ParameterGroup name="ListOfParameters">
        </ParameterGroup>
        <ParameterGroup name="ListOfTargets">
        </ParameterGroup>
      </Problem>
      <Method name="LSODA Sensitivities" type="Sensitivities(LSODA)">
        <Parameter name="Integrate Reduced Model" type="bool" value="0" />
        <Parameter name="Relative Tolerance" type="unsignedFloat" value="9.9999999999999995e-07" />
        <Parameter name="Absolute Tolerance" type="unsignedFloat" value="9.9999999999999998e-13" />
        <Parameter name="Max Internal Steps" type="unsignedInteger" value="10000" />
        <Parameter name="Max Internal Step Size" type="unsignedFloat" value="0" />
      </Method>
    </Task>
  </ListOfTasks>
  <ListOfReports>
    <Report key="Report_11" name="Steady-State" taskType="steadyState" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Footer>
        <Object cn="CN=Root,Vector=TaskList[Steady-State]" />
      </Footer>
    </Report>
    <Report key="Report_12" name="Time-Course" taskType="timeCourse" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Time-Course],Object=Description" />
      </Header>
      <Footer>
        <Object cn="CN=Root,Vector=TaskList[Time-Course],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_13" name="Elementary Flux Modes" taskType="fluxMode" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Footer>
        <Object cn="CN=Root,Vector=TaskList[Elementary Flux Modes],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_14" name="Optimization" taskType="optimization" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Object=Description" />
        <Object cn="String=\[Function Evaluations\]" />
        <Object cn="Separator=&#09;" />
        <Object cn="String=\[Best Value\]" />
        <Object cn="Separator=&#09;" />
        <Object cn="String=\[Best Parameters\]" />
      </Header>
      <Body>
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Function Evaluations" />
        <Object cn="Separator=&#09;" />
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Best Value" />
        <Object cn="Separator=&#09;" />
        <Object cn="CN=Root,Vector=TaskList[Optimization],Problem=Optimization,Reference=Best Parameters" />
      </Body>
      <Footer>
        <Object cn="String=&#10;" />
        <Object cn="CN=Root,Vector=TaskList[Optimization],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_15" name="Parameter Estimation" taskType="parameterFitting" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Object=Description" />
        <Object cn="String=\[Function Evaluations\]" />
        <Object cn="Separator=&#09;" />
        <Object cn="String=\[Best Value\]" />
        <Object cn="Separator=&#09;" />
        <Object cn="String=\[Best Parameters\]" />
      </Header>
      <Body>
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Function Evaluations" />
        <Object cn="Separator=&#09;" />
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Best Value" />
        <Object cn="Separator=&#09;" />
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Problem=Parameter Estimation,Reference=Best Parameters" />
      </Body>
      <Footer>
        <Object cn="String=&#10;" />
        <Object cn="CN=Root,Vector=TaskList[Parameter Estimation],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_16" name="Metabolic Control Analysis" taskType="metabolicControlAnalysis" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Description" />
      </Header>
      <Footer>
        <Object cn="String=&#10;" />
        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_17" name="Lyapunov Exponents" taskType="lyapunovExponents" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Lyapunov Exponents],Object=Description" />
      </Header>
      <Footer>
        <Object cn="String=&#10;" />
        <Object cn="CN=Root,Vector=TaskList[Lyapunov Exponents],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_18" name="Time Scale Separation Analysis" taskType="timeScaleSeparationAnalysis" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Time Scale Separation Analysis],Object=Description" />
      </Header>
      <Footer>
        <Object cn="String=&#10;" />
        <Object cn="CN=Root,Vector=TaskList[Time Scale Separation Analysis],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_19" name="Sensitivities" taskType="sensitivities" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Sensitivities],Object=Description" />
      </Header>
      <Footer>
        <Object cn="String=&#10;" />
        <Object cn="CN=Root,Vector=TaskList[Sensitivities],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_20" name="Moieties" taskType="moieties" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Moieties],Object=Description" />
      </Header>
      <Footer>
        <Object cn="String=&#10;" />
        <Object cn="CN=Root,Vector=TaskList[Moieties],Object=Result" />
      </Footer>
    </Report>
    <Report key="Report_21" name="Linear Noise Approximation" taskType="linearNoiseApproximation" separator="&#09;" precision="6">
      <Comment>
        Automatically generated report.
      </Comment>
      <Header>
        <Object cn="CN=Root,Vector=TaskList[Linear Noise Approximation],Object=Description" />
      </Header>
      <Footer>
        <Object cn="String=&#10;" />
        <Object cn="CN=Root,Vector=TaskList[Linear Noise Approximation],Object=Result" />
      </Footer>
    </Report>
  <Report key="Report_cross_engine" name="Concentrations in SBML identifier order" taskType="timeCourse" separator="&#09;" precision="16"><Table printTitle="1"><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Reference=Time" /><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mos],Reference=Concentration" /><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mos-P],Reference=Concentration" /><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mek1],Reference=Concentration" /><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mek1-P],Reference=Concentration" /><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Mek1-PP],Reference=Concentration" /><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Erk2],Reference=Concentration" /><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Erk2-P],Reference=Concentration" /><Object cn="CN=Root,Model=Kholodenko2000 - Ultrasensitivity and negative feedback bring oscillations in MAPK cascade,Vector=Compartments[uVol],Vector=Metabolites[Erk2-PP],Reference=Concentration" /></Table></Report></ListOfReports>
  <GUI>
  </GUI>
  <SBMLReference file="../../data/model.xml">
    <SBMLMap SBMLid="J0" COPASIkey="Reaction_0" />
    <SBMLMap SBMLid="J1" COPASIkey="Reaction_1" />
    <SBMLMap SBMLid="J2" COPASIkey="Reaction_2" />
    <SBMLMap SBMLid="J3" COPASIkey="Reaction_3" />
    <SBMLMap SBMLid="J4" COPASIkey="Reaction_4" />
    <SBMLMap SBMLid="J5" COPASIkey="Reaction_5" />
    <SBMLMap SBMLid="J6" COPASIkey="Reaction_6" />
    <SBMLMap SBMLid="J7" COPASIkey="Reaction_7" />
    <SBMLMap SBMLid="J8" COPASIkey="Reaction_8" />
    <SBMLMap SBMLid="J9" COPASIkey="Reaction_9" />
    <SBMLMap SBMLid="MAPK" COPASIkey="Metabolite_5" />
    <SBMLMap SBMLid="MAPK_P" COPASIkey="Metabolite_6" />
    <SBMLMap SBMLid="MAPK_PP" COPASIkey="Metabolite_7" />
    <SBMLMap SBMLid="MKK" COPASIkey="Metabolite_2" />
    <SBMLMap SBMLid="MKKK" COPASIkey="Metabolite_0" />
    <SBMLMap SBMLid="MKKK_P" COPASIkey="Metabolite_1" />
    <SBMLMap SBMLid="MKK_P" COPASIkey="Metabolite_3" />
    <SBMLMap SBMLid="MKK_PP" COPASIkey="Metabolite_4" />
    <SBMLMap SBMLid="uVol" COPASIkey="Compartment_0" />
  </SBMLReference>
  <ListOfUnitDefinitions>
    <UnitDefinition key="Unit_1" name="meter" symbol="m">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Unit_0">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        m
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_5" name="second" symbol="s">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Unit_4">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        s
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_13" name="Avogadro" symbol="Avogadro">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Unit_12">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        Avogadro
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_17" name="item" symbol="#">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Unit_16">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        #
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_35" name="liter" symbol="l">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Unit_34">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        0.001*m^3
      </Expression>
    </UnitDefinition>
    <UnitDefinition key="Unit_41" name="mole" symbol="mol">
      <MiriamAnnotation>
<rdf:RDF>
<rdf:Description rdf:about="#Unit_40">
</rdf:Description>
</rdf:RDF>
      </MiriamAnnotation>
      <Expression>
        Avogadro*#
      </Expression>
    </UnitDefinition>
  </ListOfUnitDefinitions>
</COPASI>