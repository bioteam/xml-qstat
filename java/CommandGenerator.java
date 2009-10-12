/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.xmlqstat.generator;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.Serializable;
import org.apache.avalon.framework.configuration.Configuration;
import org.apache.avalon.framework.configuration.ConfigurationException;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.components.source.SourceUtil;
import org.xml.sax.SAXException;
import org.apache.avalon.framework.service.ServiceException;
import org.apache.cocoon.ProcessingException;
import org.apache.excalibur.source.SourceException;
import org.apache.excalibur.xml.sax.SAXParser;
import org.xml.sax.SAXException;
import java.io.IOException;
import org.apache.cocoon.generation.ServiceableGenerator;
import org.xml.sax.InputSource;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.components.source.SourceUtil;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.excalibur.source.SourceException;
import org.xml.sax.SAXException;
import java.io.IOException;
import java.util.Map;
import org.apache.avalon.framework.configuration.Configurable;
import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.excalibur.source.SourceValidity;

/**
 * @cocoon.sitemap.component.documentation
 * The <code>CommandGenerator</code> is a class that reads XML from a
 * InputStream of executed command and generates SAX Events.
 *
 * @cocoon.sitemap.component.name   command
 * @cocoon.sitemap.component.label  content
 * @cocoon.sitemap.component.logger sitemap.generator.command
 *
 * @cocoon.sitemap.component.pooling.max  16
 *
 *
 * @author <a href="mailto:Petr.Jung@sun.com">Petr Jung</a>
 * @version CVS $Id: CommandGenerator.java $
 */
public class CommandGenerator extends ServiceableGenerator implements CacheableProcessingComponent, Configurable {

   /* expire delay, fixed for 30sec, but should be read from configuration */
   static final long EXPIRE_DEFAULT = 30L;
   static final String EXPIRE_TAG = "expire";

   /** The input source */
   protected InputSource inputSource;
   /* expire delay in seconds */
   protected long expire;
   /** The validity that is being built */
   protected ExpireValidity validity;

   public void configure(Configuration conf) throws ConfigurationException {
      this.expire = conf.getChild(EXPIRE_TAG).getValueAsLong(EXPIRE_DEFAULT);
   }

   /**
    * Recycle this component.
    * All instance variables are set to <code>null</code>.
    */
   @Override
   public void recycle() {
      super.recycle();
      this.inputSource = null;
   }

   /**
    * Setup the command file generator.
    * @param resolver the url resolver
    * @param objectModel the attribute model
    * @param source the mapped source url
    * @param par a parameters
    * @throws org.apache.cocoon.ProcessingException
    * @throws org.xml.sax.SAXException
    * @throws java.io.IOException
    */
   @Override
   public void setup(SourceResolver resolver, Map objectModel, String source, Parameters par) throws ProcessingException, SAXException, IOException {
      super.setup(resolver, objectModel, source, par);
      this.inputSource = runShellCommand(source);
   }

   /**
    * Parse XML data form provided xml output.
    * @throws java.io.IOException
    * @throws org.xml.sax.SAXException
    * @throws org.apache.cocoon.ProcessingException
    */
   public void generate() throws IOException, SAXException, ProcessingException {
      // Parse the xml from the command
      SAXParser parser = null;
      try {
         parser = (SAXParser) manager.lookup(SAXParser.ROLE);
         parser.parse(inputSource, super.xmlConsumer);
      } catch (SourceException e) {
         throw SourceUtil.handle(e);
      } catch (ServiceException e) {
         throw new ProcessingException("Exception during parsing source.", e);
      } catch (SAXException e) {
         SourceUtil.handleSAXException(this.source, e);
      } finally {
         manager.release(parser);
      }
   }

   /**
    * Call command shell and store the output stream
    * @param cmds a command string to be executed
    * @return the output of the command as a InputSource
    * @throws java.io.IOException
    */
   public InputSource runShellCommand(String cmds) throws IOException {
      if (getLogger().isDebugEnabled()) {
         getLogger().debug("call system command " + cmds);
      }
      try {
         Process p = Runtime.getRuntime().exec(cmds);
         final BufferedInputStream output = new BufferedInputStream(p.getInputStream());
         p.waitFor();
         return new InputSource(output);
      } catch (Exception ex) {
         if (getLogger().isDebugEnabled()) {
            getLogger().debug("call system command exception" + source, ex);
         }
         throw new IOException(ex.getMessage());
      }
   }

   public Serializable getKey() {
      return source;
   }

   public SourceValidity getValidity() {
      if (this.validity == null) {
         this.validity = new ExpireValidity(expire);
      }
      return this.validity;
   }

   /** Specific validity class */
   public static class ExpireValidity implements SourceValidity {

      static final long MILLIS = 1000l;
      private long validTo = System.currentTimeMillis()+MILLIS;
      private long expire;

      /* expire is in miliseconds */
      public ExpireValidity(long expire) {
         this.expire = expire;
      }

      public int isValid() {
         if (System.currentTimeMillis() <= validTo) {
            return SourceValidity.VALID;
         }
         validTo = System.currentTimeMillis() + expire * MILLIS;
         return SourceValidity.INVALID;
      }

      public int isValid(SourceValidity newValidity) {
         return isValid();
      }
   }
}
