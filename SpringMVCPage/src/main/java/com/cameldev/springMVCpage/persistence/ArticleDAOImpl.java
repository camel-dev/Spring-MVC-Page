package com.cameldev.springMVCpage.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.cameldev.springMVCpage.domain.ArticleVO;
import com.cameldev.springMVCpage.commons.paging.Criteria;
import com.cameldev.springMVCpage.commons.paging.SearchCriteria;

@Repository
public class ArticleDAOImpl implements ArticleDAO {

    private static final String NAMESPACE = "com.cameldev.springMVCpage.mappers.article.ArticleMapper";

    private final SqlSession sqlSession;

    @Inject
    public ArticleDAOImpl(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public void create(ArticleVO articleVO) throws Exception {
        sqlSession.insert(NAMESPACE + ".create", articleVO);
    }
    
 // 회원 프로필 사진 수정
    @Override
    public void updateWriterImg(ArticleVO articleVO) throws Exception {
        sqlSession.update(NAMESPACE + ".updateWriterImg", articleVO);
    }

    @Override
    public ArticleVO read(Integer article_no) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".read", article_no);
    }

    @Override
    public void update(ArticleVO articleVO) throws Exception {
        sqlSession.update(NAMESPACE + ".update", articleVO);
    }

    @Override
    public void delete(Integer article_no) throws Exception {
        sqlSession.delete(NAMESPACE + ".delete", article_no);
    }

    @Override
    public List<ArticleVO> listAll() throws Exception {
        return sqlSession.selectList(NAMESPACE + ".listAll");
    }
    
    @Override
    public List<ArticleVO> listPaging(int page) throws Exception {

        if (page <= 0) {
            page = 1;
        }

        page = (page - 1) * 10;

        return sqlSession.selectList(NAMESPACE + ".listPaging", page);
    }
    
    @Override
    public List<ArticleVO> listCriteria(Criteria criteria) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".listCriteria", criteria);
    }
    
    @Override
    public List<ArticleVO> listSearch(SearchCriteria searchCriteria) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".listSearch", searchCriteria);
    }
    
    @Override
    public int countArticles(Criteria criteria) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countArticles", criteria);
    }
    
    @Override
    public int countSearchedArticles(SearchCriteria searchCriteria) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".countSearchedArticles", searchCriteria);
    }
    
    @Override
    public void updateReplycnt(Integer article_no, int amount) throws Exception {

        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("article_no", article_no);
        paramMap.put("amount", amount);

        sqlSession.update(NAMESPACE + ".updateReplycnt",paramMap);
    }
    
    @Override
    public void updateViewcnt(Integer article_no) throws Exception {
        sqlSession.update(NAMESPACE + ".updateViewcnt", article_no);
    }
    
 // 회원이 작성한 게시글 목록
    @Override
    public List<ArticleVO> userBoardList(String userId) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".userBoardList", userId);
    }
}