package com.kh.almin.recruit.model.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.almin.recruit.model.dao.RecruitDao;
import com.kh.almin.recruit.model.vo.LikeRecruit;
import com.kh.almin.recruit.model.vo.Recruit;
import com.kh.almin.recruit.model.vo.SearchRecruit;

@Service
public class RecruitServiceImpl implements RecruitService {
	private static final Logger logger = LoggerFactory.getLogger(RecruitServiceImpl.class);
	@Autowired
	private RecruitDao recruitDao;

	public List<Recruit> getReport() throws Exception {
		logger.info("Service 로깅 확인");
		return recruitDao.getReport();
	}

	public List<Recruit> recruitList() throws Exception {
		return recruitDao.recruitList();
	}

	public Recruit detailjobinfo(int recruitNo) throws Exception {
		return recruitDao.detailjobinfo(recruitNo);
	}

	public List<Recruit> searchRecruit(SearchRecruit searchRecruit) throws Exception {
		return recruitDao.searchRecruit(searchRecruit);
	}

	public int reportRecruit(int recruitNo) throws Exception {
		return recruitDao.reportRecruit(recruitNo);
	}

	public int likeRecruit(LikeRecruit likeRecruit) throws Exception {
		return recruitDao.likeRecruit(likeRecruit);
	}

	public int dislikeRecruit(LikeRecruit likeRecruit) throws Exception {
		return recruitDao.dislikeRecruit(likeRecruit);
	}

	public List<Recruit> listLike(String memberId) throws Exception {
		return recruitDao.listLike(memberId);
	}

	public int checkLike(LikeRecruit likeRecruit) throws Exception {
		return recruitDao.checkLike(likeRecruit);
	}
}
