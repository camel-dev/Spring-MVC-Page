package com.cameldev.springMVCpage.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.cameldev.springMVCpage.domain.ArticleVO;
import com.cameldev.springMVCpage.persistence.ArticleDAO;
import com.cameldev.springMVCpage.commons.paging.Criteria;
import com.cameldev.springMVCpage.commons.paging.SearchCriteria;
import com.cameldev.springMVCpage.persistence.UploadDAO;
@Service
public class ArticleServiceImpl implements ArticleService {

    private final ArticleDAO articleDAO;
    
    private static final Logger logger = LoggerFactory.getLogger(ArticleServiceImpl.class);
    
    private UploadDAO uploadDAO;

    @Inject
    public ArticleServiceImpl(ArticleDAO articleDAO, UploadDAO uploadDAO) {
        this.articleDAO = articleDAO;
        this.uploadDAO = uploadDAO;
    }
    
    @Transactional
    @Override
    public void create(ArticleVO articleVO) throws Exception {
        String[] files = articleVO.getFiles();  
        
        
        
        if (files == null) {
        	
        	articleDAO.create(articleVO);
        	articleDAO.updateWriterImg(articleVO);
        	logger.info("Create - "+articleVO.toString());
            return;
        }
        articleVO.setFileCnt(files.length);
        
        articleDAO.create(articleVO);
        articleDAO.updateWriterImg(articleVO);
        logger.info("Create - "+articleVO.toString());
        Integer article_no = articleVO.getArticle_no();
        for (String fileName : files) {
        	logger.info("File exist. . .");
            uploadDAO.addAttach(fileName, article_no);
        }

    }
    
    @Transactional(isolation = Isolation.READ_COMMITTED)
    @Override
    public ArticleVO read(Integer article_no) throws Exception {
    	articleDAO.updateViewcnt(article_no);
        return articleDAO.read(article_no);
    }
    
    @Transactional
    @Override
    public void update(ArticleVO articleVO) throws Exception {
    	
        
        int article_no = articleVO.getArticle_no();
        uploadDAO.deleteAllAttach(article_no);

        String[] files = articleVO.getFiles();
        if (files == null) {
        	articleVO.setFileCnt(0);
            articleDAO.update(articleVO);
            return;
        }

        articleVO.setFileCnt(files.length);
        articleDAO.update(articleVO);
        for (String fileName : files) {
            uploadDAO.replaceAttach(fileName, article_no);
        }
    }

    @Transactional
    @Override
    public void delete(Integer article_no) throws Exception {
    	uploadDAO.deleteAllAttach(article_no);
        articleDAO.delete(article_no);
    }

    @Override
    public List<ArticleVO> listAll() throws Exception {
        return articleDAO.listAll();
    }
    
    @Override
    public List<ArticleVO> listCriteria(Criteria criteria) throws Exception {
        return articleDAO.listCriteria(criteria);
    }
    
    @Override
    public int countArticles(Criteria criteria) throws Exception {
        return articleDAO.countArticles(criteria);
    }
   
    @Override
    public List<ArticleVO> listSearch(SearchCriteria searchCriteria) throws Exception {
        return articleDAO.listSearch(searchCriteria);
    }

    @Override
    public int countSearchedArticles(SearchCriteria searchCriteria) throws Exception {
        return articleDAO.countSearchedArticles(searchCriteria);
    }
    
 // 회원이 작성한 게시글 목록
    @Override
    public List<ArticleVO> userBoardList(String uid) throws Exception {
        return articleDAO.userBoardList(uid);
    }
}